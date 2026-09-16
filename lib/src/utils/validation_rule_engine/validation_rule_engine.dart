import 'package:flutter/foundation.dart' show compute;

import '../../../objectbox.dart';
import '../../models/metadata/org_unit.dart';
import '../../models/metadata/validation_rule.dart';
import '../period_engine/models/period.dart';
import 'helpers/expression/expression_functions.dart';
import 'helpers/expression_evaluator.dart';
import 'models/validation_result.dart';

class D2RuleEvaluationOutcome {
  final double leftSideValue;
  final double rightSideValue;

  const D2RuleEvaluationOutcome(this.leftSideValue, this.rightSideValue);
}

class D2ValidationRuleEngine {
  final List<D2ValidationRule> validationRules;

  D2ValidationRuleEngine({required this.validationRules});

  D2ValidationResult validate(
    Map<String, String> dataValues, {
    D2OrgUnit? currentOrgUnit,
    D2ObjectBox? db,
    D2Period? period,
  }) {
    final List<D2ValidationViolation> violations = [];

    for (final rule in validationRules) {
      if (rule.skipFormValidation) continue;

      final outcome = _evaluateRuleValues(
        operator: rule.operator,
        leftSideExpression: rule.leftSideExpression,
        leftSideMissingValueStrategy: rule.leftSideMissingValueStrategy,
        rightSideExpression: rule.rightSideExpression,
        rightSideMissingValueStrategy: rule.rightSideMissingValueStrategy,
        dataValues: dataValues,
        currentOrgUnit: currentOrgUnit,
        db: db,
        period: period,
      );
      if (outcome != null) {
        violations.add(
          D2ValidationViolation(
            rule: rule,
            leftSideValue: outcome.leftSideValue,
            rightSideValue: outcome.rightSideValue,
          ),
        );
      }
    }

    return D2ValidationResult(violations: violations);
  }

  Future<D2ValidationResult> validateInIsolate(
    Map<String, String> dataValues, {
    D2OrgUnit? currentOrgUnit,
    D2ObjectBox? db,
    D2Period? period,
  }) async {
    final rulesByUid = <String, D2ValidationRule>{};
    final flatRules = <_D2FlatValidationRule>[];
    final orgUnitRefs = <(String, String)>{};

    for (final rule in validationRules) {
      if (rule.skipFormValidation) continue;
      rulesByUid[rule.uid] = rule;
      flatRules.add(
        _D2FlatValidationRule(
          uid: rule.uid,
          operator: rule.operator,
          leftSideExpression: rule.leftSideExpression,
          leftSideMissingValueStrategy: rule.leftSideMissingValueStrategy,
          rightSideExpression: rule.rightSideExpression,
          rightSideMissingValueStrategy: rule.rightSideMissingValueStrategy,
        ),
      );
      orgUnitRefs.addAll(d2ExtractOrgUnitFunctionRefs(rule.leftSideExpression));
      orgUnitRefs.addAll(
        d2ExtractOrgUnitFunctionRefs(rule.rightSideExpression),
      );
    }

    final orgUnitFunctionAnswers = <String, bool>{
      for (final (function, uid) in orgUnitRefs)
        '$function:$uid': d2ResolveOrgUnitFunctionAnswer(
          function,
          uid,
          currentOrgUnit,
          db,
        ),
    };

    final flatViolations = await compute(
      _evaluateFlatRulesInIsolate,
      _D2IsolateValidateInput(
        rules: flatRules,
        dataValues: dataValues,
        period: period,
        orgUnitFunctionAnswers: orgUnitFunctionAnswers,
      ),
    );

    final violations = flatViolations
        .map(
          (v) => D2ValidationViolation(
            rule: rulesByUid[v.ruleUid]!,
            leftSideValue: v.leftSideValue,
            rightSideValue: v.rightSideValue,
          ),
        )
        .toList();

    return D2ValidationResult(violations: violations);
  }
}

D2RuleEvaluationOutcome? _evaluateRuleValues({
  required String operator,
  required String leftSideExpression,
  required String leftSideMissingValueStrategy,
  required String rightSideExpression,
  required String rightSideMissingValueStrategy,
  required Map<String, String> dataValues,
  D2OrgUnit? currentOrgUnit,
  D2ObjectBox? db,
  D2Period? period,
  Map<String, bool>? orgUnitFunctionAnswers,
}) {
  final leftOperands = ExpressionEvaluator.extractOperands(leftSideExpression);
  final rightOperands = ExpressionEvaluator.extractOperands(
    rightSideExpression,
  );

  if (operator == 'compulsory_pair') {
    return _pairOutcome(
      leftOperands,
      rightOperands,
      dataValues,
      violateIfBothPresent: false,
    );
  }
  if (operator == 'exclusive_pair') {
    return _pairOutcome(
      leftOperands,
      rightOperands,
      dataValues,
      violateIfBothPresent: true,
    );
  }

  if (_shouldSkip(leftOperands, dataValues, leftSideMissingValueStrategy)) {
    return null;
  }
  if (_shouldSkip(rightOperands, dataValues, rightSideMissingValueStrategy)) {
    return null;
  }

  final leftValue = ExpressionEvaluator.evaluate(
    leftSideExpression,
    dataValues,
    leftSideMissingValueStrategy,
    currentOrgUnit: currentOrgUnit,
    db: db,
    period: period,
    orgUnitFunctionAnswers: orgUnitFunctionAnswers,
  );
  final rightValue = ExpressionEvaluator.evaluate(
    rightSideExpression,
    dataValues,
    rightSideMissingValueStrategy,
    currentOrgUnit: currentOrgUnit,
    db: db,
    period: period,
    orgUnitFunctionAnswers: orgUnitFunctionAnswers,
  );

  if (leftValue == null || rightValue == null) return null;

  final passes = _compare(leftValue, rightValue, operator);
  if (passes) return null;

  return D2RuleEvaluationOutcome(leftValue, rightValue);
}

D2RuleEvaluationOutcome? _pairOutcome(
  List<String> leftOperands,
  List<String> rightOperands,
  Map<String, String> dataValues, {
  required bool violateIfBothPresent,
}) {
  final leftHasAny = leftOperands.any((op) => _hasValue(op, dataValues));
  final rightHasAny = rightOperands.any((op) => _hasValue(op, dataValues));

  if (violateIfBothPresent) {
    if (leftHasAny && rightHasAny) {
      return const D2RuleEvaluationOutcome(1.0, 1.0);
    }
    return null;
  }

  if (leftHasAny != rightHasAny) {
    return D2RuleEvaluationOutcome(
      leftHasAny ? 1.0 : 0.0,
      rightHasAny ? 1.0 : 0.0,
    );
  }
  return null;
}

bool _shouldSkip(
  List<String> operands,
  Map<String, String> dataValues,
  String missingValueStrategy,
) {
  switch (missingValueStrategy) {
    case 'SKIP_IF_ANY_VALUE_MISSING':
      return operands.any((op) => !_hasValue(op, dataValues));
    case 'SKIP_IF_ALL_VALUES_MISSING':
      return operands.every((op) => !_hasValue(op, dataValues));
    case 'NEVER_SKIP':
      return false;
    default:
      return operands.every((op) => !_hasValue(op, dataValues));
  }
}

bool _hasValue(String operand, Map<String, String> dataValues) {
  final value = dataValues[operand];
  return value != null && value.trim().isNotEmpty;
}

bool _compare(double leftValue, double rightValue, String operator) {
  switch (operator) {
    case 'equal_to':
      return leftValue == rightValue;
    case 'not_equal_to':
      return leftValue != rightValue;
    case 'greater_than':
      return leftValue > rightValue;
    case 'greater_than_or_equal_to':
      return leftValue >= rightValue;
    case 'less_than':
      return leftValue < rightValue;
    case 'less_than_or_equal_to':
      return leftValue <= rightValue;
    default:
      return true;
  }
}

class _D2FlatValidationRule {
  final String uid;
  final String operator;
  final String leftSideExpression;
  final String leftSideMissingValueStrategy;
  final String rightSideExpression;
  final String rightSideMissingValueStrategy;

  const _D2FlatValidationRule({
    required this.uid,
    required this.operator,
    required this.leftSideExpression,
    required this.leftSideMissingValueStrategy,
    required this.rightSideExpression,
    required this.rightSideMissingValueStrategy,
  });
}

class _D2IsolateValidateInput {
  final List<_D2FlatValidationRule> rules;
  final Map<String, String> dataValues;
  final D2Period? period;
  final Map<String, bool> orgUnitFunctionAnswers;

  const _D2IsolateValidateInput({
    required this.rules,
    required this.dataValues,
    required this.orgUnitFunctionAnswers,
    this.period,
  });
}

class _D2FlatValidationViolation {
  final String ruleUid;
  final double leftSideValue;
  final double rightSideValue;

  const _D2FlatValidationViolation({
    required this.ruleUid,
    required this.leftSideValue,
    required this.rightSideValue,
  });
}

List<_D2FlatValidationViolation> _evaluateFlatRulesInIsolate(
  _D2IsolateValidateInput input,
) {
  final violations = <_D2FlatValidationViolation>[];

  for (final rule in input.rules) {
    final outcome = _evaluateRuleValues(
      operator: rule.operator,
      leftSideExpression: rule.leftSideExpression,
      leftSideMissingValueStrategy: rule.leftSideMissingValueStrategy,
      rightSideExpression: rule.rightSideExpression,
      rightSideMissingValueStrategy: rule.rightSideMissingValueStrategy,
      dataValues: input.dataValues,
      period: input.period,
      orgUnitFunctionAnswers: input.orgUnitFunctionAnswers,
    );
    if (outcome != null) {
      violations.add(
        _D2FlatValidationViolation(
          ruleUid: rule.uid,
          leftSideValue: outcome.leftSideValue,
          rightSideValue: outcome.rightSideValue,
        ),
      );
    }
  }

  return violations;
}
