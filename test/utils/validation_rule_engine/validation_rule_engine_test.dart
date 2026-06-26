import 'package:dhis2_flutter_toolkit/src/models/metadata/validation_rule.dart';
import 'package:dhis2_flutter_toolkit/src/utils/validation_rule_engine/models/validation_result.dart';
import 'package:dhis2_flutter_toolkit/src/utils/validation_rule_engine/validation_rule_engine.dart';
import 'package:flutter_test/flutter_test.dart';

D2ValidationRule _makeRule({
  String uid = 'rule1',
  String name = 'Test Rule',
  String? instruction,
  String importance = 'MEDIUM',
  String operator = 'less_than_or_equal_to',
  bool skipFormValidation = false,
  String leftSideExpression = '#{uid1.uid2}',
  String? leftSideDescription,
  String leftSideMissingValueStrategy = 'SKIP_IF_ALL_VALUES_MISSING',
  String rightSideExpression = '#{uid3.uid4}',
  String? rightSideDescription,
  String rightSideMissingValueStrategy = 'SKIP_IF_ALL_VALUES_MISSING',
}) {
  return D2ValidationRule(
    0,
    uid,
    DateTime.now(),
    DateTime.now(),
    name,
    null,
    instruction,
    importance,
    operator,
    null,
    skipFormValidation,
    leftSideExpression,
    leftSideDescription,
    leftSideMissingValueStrategy,
    false,
    rightSideExpression,
    rightSideDescription,
    rightSideMissingValueStrategy,
    false,
  );
}

void main() {
  group('D2ValidationRuleEngine', () {
    test('returns no violations when rule passes', () {
      final rule = _makeRule(operator: 'less_than_or_equal_to');
      final engine = D2ValidationRuleEngine(validationRules: [rule]);

      final result = engine.validate({'uid1.uid2': '5', 'uid3.uid4': '10'});

      expect(result.hasViolations, false);
      expect(result.violations, isEmpty);
    });

    test('returns violation when rule fails', () {
      final rule = _makeRule(operator: 'less_than_or_equal_to');
      final engine = D2ValidationRuleEngine(validationRules: [rule]);

      final result = engine.validate({'uid1.uid2': '15', 'uid3.uid4': '10'});

      expect(result.hasViolations, true);
      expect(result.violations.length, 1);
      expect(result.violations.first.leftSideValue, 15.0);
      expect(result.violations.first.rightSideValue, 10.0);
    });

    test('equal_to operator passes when values are equal', () {
      final rule = _makeRule(operator: 'equal_to');
      final engine = D2ValidationRuleEngine(validationRules: [rule]);

      final result = engine.validate({'uid1.uid2': '5', 'uid3.uid4': '5'});

      expect(result.hasViolations, false);
    });

    test('equal_to operator fails when values differ', () {
      final rule = _makeRule(operator: 'equal_to');
      final engine = D2ValidationRuleEngine(validationRules: [rule]);

      final result = engine.validate({'uid1.uid2': '5', 'uid3.uid4': '10'});

      expect(result.hasViolations, true);
    });

    test('greater_than operator', () {
      final rule = _makeRule(operator: 'greater_than');
      final engine = D2ValidationRuleEngine(validationRules: [rule]);

      expect(
        engine.validate({'uid1.uid2': '10', 'uid3.uid4': '5'}).hasViolations,
        false,
      );
      expect(
        engine.validate({'uid1.uid2': '5', 'uid3.uid4': '10'}).hasViolations,
        true,
      );
    });

    test('not_equal_to operator', () {
      final rule = _makeRule(operator: 'not_equal_to');
      final engine = D2ValidationRuleEngine(validationRules: [rule]);

      expect(
        engine.validate({'uid1.uid2': '5', 'uid3.uid4': '10'}).hasViolations,
        false,
      );
      expect(
        engine.validate({'uid1.uid2': '5', 'uid3.uid4': '5'}).hasViolations,
        true,
      );
    });

    test('SKIP_IF_ANY_VALUE_MISSING skips when one value missing', () {
      final rule = _makeRule(
        operator: 'less_than_or_equal_to',
        leftSideMissingValueStrategy: 'SKIP_IF_ANY_VALUE_MISSING',
      );
      final engine = D2ValidationRuleEngine(validationRules: [rule]);

      final result = engine.validate({'uid3.uid4': '10'});

      expect(result.hasViolations, false);
    });

    test('SKIP_IF_ALL_VALUES_MISSING does NOT skip when only some missing', () {
      final rule = _makeRule(
        operator: 'less_than_or_equal_to',
        leftSideExpression: '#{a.b} + #{c.d}',
        leftSideMissingValueStrategy: 'SKIP_IF_ALL_VALUES_MISSING',
      );
      final engine = D2ValidationRuleEngine(validationRules: [rule]);

      final result = engine.validate({'a.b': '15', 'uid3.uid4': '10'});

      expect(result.hasViolations, true);
    });

    test('SKIP_IF_ALL_VALUES_MISSING skips when ALL values missing', () {
      final rule = _makeRule(
        operator: 'less_than_or_equal_to',
        leftSideExpression: '#{a.b} + #{c.d}',
        leftSideMissingValueStrategy: 'SKIP_IF_ALL_VALUES_MISSING',
      );
      final engine = D2ValidationRuleEngine(validationRules: [rule]);

      final result = engine.validate({'uid3.uid4': '10'});

      expect(result.hasViolations, false);
    });

    test('NEVER_SKIP treats missing values as 0', () {
      final rule = _makeRule(
        operator: 'greater_than',
        leftSideMissingValueStrategy: 'NEVER_SKIP',
        rightSideMissingValueStrategy: 'NEVER_SKIP',
      );
      final engine = D2ValidationRuleEngine(validationRules: [rule]);

      // left=0 (missing), right=0 (missing); 0 > 0 is false => violation
      final result = engine.validate({});

      expect(result.hasViolations, true);
    });

    test('skipFormValidation flag causes rule to be skipped', () {
      final rule = _makeRule(
        operator: 'equal_to',
        skipFormValidation: true,
      );
      final engine = D2ValidationRuleEngine(validationRules: [rule]);

      final result = engine.validate({'uid1.uid2': '5', 'uid3.uid4': '10'});

      expect(result.hasViolations, false);
    });

    test('compulsory_pair violation when only left side has value', () {
      final rule = _makeRule(operator: 'compulsory_pair');
      final engine = D2ValidationRuleEngine(validationRules: [rule]);

      final result = engine.validate({'uid1.uid2': '5'});

      expect(result.hasViolations, true);
    });

    test('compulsory_pair passes when both sides have values', () {
      final rule = _makeRule(operator: 'compulsory_pair');
      final engine = D2ValidationRuleEngine(validationRules: [rule]);

      final result = engine.validate({'uid1.uid2': '5', 'uid3.uid4': '10'});

      expect(result.hasViolations, false);
    });

    test('compulsory_pair passes when neither side has values', () {
      final rule = _makeRule(operator: 'compulsory_pair');
      final engine = D2ValidationRuleEngine(validationRules: [rule]);

      final result = engine.validate({});

      expect(result.hasViolations, false);
    });

    test('exclusive_pair violation when both sides have values', () {
      final rule = _makeRule(operator: 'exclusive_pair');
      final engine = D2ValidationRuleEngine(validationRules: [rule]);

      final result = engine.validate({'uid1.uid2': '5', 'uid3.uid4': '10'});

      expect(result.hasViolations, true);
    });

    test('exclusive_pair passes when only one side has value', () {
      final rule = _makeRule(operator: 'exclusive_pair');
      final engine = D2ValidationRuleEngine(validationRules: [rule]);

      final result = engine.validate({'uid1.uid2': '5'});

      expect(result.hasViolations, false);
    });

    test('multiple rules return all violations', () {
      final rule1 = _makeRule(
        uid: 'r1',
        name: 'Rule 1',
        operator: 'equal_to',
        leftSideExpression: '#{a.b}',
        rightSideExpression: '#{c.d}',
      );
      final rule2 = _makeRule(
        uid: 'r2',
        name: 'Rule 2',
        operator: 'less_than',
        leftSideExpression: '#{e.f}',
        rightSideExpression: '#{g.h}',
      );
      final engine = D2ValidationRuleEngine(validationRules: [rule1, rule2]);

      final result = engine.validate({
        'a.b': '5',
        'c.d': '10',
        'e.f': '20',
        'g.h': '10',
      });

      expect(result.violations.length, 2);
    });

    test('importance filtering works on result', () {
      final highRule = _makeRule(
        uid: 'r1',
        operator: 'equal_to',
        importance: 'HIGH',
      );
      final lowRule = _makeRule(
        uid: 'r2',
        operator: 'equal_to',
        importance: 'LOW',
        leftSideExpression: '#{a.b}',
        rightSideExpression: '#{c.d}',
      );
      final engine = D2ValidationRuleEngine(validationRules: [highRule, lowRule]);

      final result = engine.validate({
        'uid1.uid2': '1',
        'uid3.uid4': '2',
        'a.b': '3',
        'c.d': '4',
      });

      expect(result.highImportanceViolations.length, 1);
      expect(result.lowImportanceViolations.length, 1);
      expect(result.mediumImportanceViolations.length, 0);
    });
  });

  group('D2ValidationViolation', () {
    test('description returns instruction when available', () {
      final rule = _makeRule(instruction: 'Check ANC values');
      final violation = D2ValidationViolation(
        rule: rule,
        leftSideValue: 10,
        rightSideValue: 5,
      );

      expect(violation.description, 'Check ANC values');
    });

    test('description falls back to side descriptions', () {
      final rule = _makeRule(
        leftSideDescription: 'ANC 2',
        rightSideDescription: 'ANC 1',
      );
      final violation = D2ValidationViolation(
        rule: rule,
        leftSideValue: 10,
        rightSideValue: 5,
      );

      expect(violation.description, 'ANC 2 <= ANC 1');
    });
  });
}
