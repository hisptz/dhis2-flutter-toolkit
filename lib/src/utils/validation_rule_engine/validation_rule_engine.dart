import '../../models/metadata/validation_rule.dart';
import 'helpers/expression_evaluator.dart';
import 'models/validation_result.dart';

class D2ValidationRuleEngine {
  final List<D2ValidationRule> validationRules;

  D2ValidationRuleEngine({required this.validationRules});

  D2ValidationResult validate(Map<String, String> dataValues) {
    final List<D2ValidationViolation> violations = [];

    for (final rule in validationRules) {
      if (rule.skipFormValidation) continue;

      final violation = _evaluateRule(rule, dataValues);
      if (violation != null) {
        violations.add(violation);
      }
    }

    return D2ValidationResult(violations: violations);
  }

  D2ValidationViolation? _evaluateRule(
    D2ValidationRule rule,
    Map<String, String> dataValues,
  ) {
    final leftOperands =
        ExpressionEvaluator.extractOperands(rule.leftSideExpression);
    final rightOperands =
        ExpressionEvaluator.extractOperands(rule.rightSideExpression);

    if (rule.operator == 'compulsory_pair') {
      return _evaluateCompulsoryPair(
          rule, leftOperands, rightOperands, dataValues);
    }
    if (rule.operator == 'exclusive_pair') {
      return _evaluateExclusivePair(
          rule, leftOperands, rightOperands, dataValues);
    }

    if (_shouldSkip(
        leftOperands, dataValues, rule.leftSideMissingValueStrategy)) {
      return null;
    }
    if (_shouldSkip(
        rightOperands, dataValues, rule.rightSideMissingValueStrategy)) {
      return null;
    }

    final leftValue = ExpressionEvaluator.evaluate(
      rule.leftSideExpression,
      dataValues,
      rule.leftSideMissingValueStrategy,
    );
    final rightValue = ExpressionEvaluator.evaluate(
      rule.rightSideExpression,
      dataValues,
      rule.rightSideMissingValueStrategy,
    );

    if (leftValue == null || rightValue == null) return null;

    final passes = _compare(leftValue, rightValue, rule.operator);

    if (!passes) {
      return D2ValidationViolation(
        rule: rule,
        leftSideValue: leftValue,
        rightSideValue: rightValue,
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

  D2ValidationViolation? _evaluateCompulsoryPair(
    D2ValidationRule rule,
    List<String> leftOperands,
    List<String> rightOperands,
    Map<String, String> dataValues,
  ) {
    final leftHasAny = leftOperands.any((op) => _hasValue(op, dataValues));
    final rightHasAny = rightOperands.any((op) => _hasValue(op, dataValues));

    if (leftHasAny != rightHasAny) {
      return D2ValidationViolation(
        rule: rule,
        leftSideValue: leftHasAny ? 1.0 : 0.0,
        rightSideValue: rightHasAny ? 1.0 : 0.0,
      );
    }
    return null;
  }

  D2ValidationViolation? _evaluateExclusivePair(
    D2ValidationRule rule,
    List<String> leftOperands,
    List<String> rightOperands,
    Map<String, String> dataValues,
  ) {
    final leftHasAny = leftOperands.any((op) => _hasValue(op, dataValues));
    final rightHasAny = rightOperands.any((op) => _hasValue(op, dataValues));

    if (leftHasAny && rightHasAny) {
      return D2ValidationViolation(
        rule: rule,
        leftSideValue: 1.0,
        rightSideValue: 1.0,
      );
    }
    return null;
  }
}
