import 'package:dhis2_flutter_toolkit/src/utils/validation_rule_engine/helpers/expression_evaluator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExpressionEvaluator.extractOperands', () {
    test('extracts single operand', () {
      final operands =
          ExpressionEvaluator.extractOperands('#{fbfJHSPpUQD.pq2XI5kz2BY}');
      expect(operands, ['fbfJHSPpUQD.pq2XI5kz2BY']);
    });

    test('extracts multiple operands', () {
      final operands = ExpressionEvaluator.extractOperands(
          '#{uid1.uid2} + #{uid3.uid4}');
      expect(operands, ['uid1.uid2', 'uid3.uid4']);
    });

    test('extracts operand without category option combo', () {
      final operands = ExpressionEvaluator.extractOperands('#{fbfJHSPpUQD}');
      expect(operands, ['fbfJHSPpUQD']);
    });

    test('returns empty list for expression with no operands', () {
      final operands = ExpressionEvaluator.extractOperands('42');
      expect(operands, isEmpty);
    });
  });

  group('ExpressionEvaluator.evaluate', () {
    test('resolves single operand to its value', () {
      final result = ExpressionEvaluator.evaluate(
        '#{uid1.uid2}',
        {'uid1.uid2': '10'},
        'NEVER_SKIP',
      );
      expect(result, 10.0);
    });

    test('evaluates addition of two operands', () {
      final result = ExpressionEvaluator.evaluate(
        '#{uid1.uid2} + #{uid3.uid4}',
        {'uid1.uid2': '5', 'uid3.uid4': '3'},
        'NEVER_SKIP',
      );
      expect(result, 8.0);
    });

    test('evaluates subtraction', () {
      final result = ExpressionEvaluator.evaluate(
        '#{uid1.uid2} - #{uid3.uid4}',
        {'uid1.uid2': '10', 'uid3.uid4': '3'},
        'NEVER_SKIP',
      );
      expect(result, 7.0);
    });

    test('evaluates multiplication', () {
      final result = ExpressionEvaluator.evaluate(
        '#{uid1.uid2} * 2',
        {'uid1.uid2': '5'},
        'NEVER_SKIP',
      );
      expect(result, 10.0);
    });

    test('evaluates division', () {
      final result = ExpressionEvaluator.evaluate(
        '#{uid1.uid2} / #{uid3.uid4}',
        {'uid1.uid2': '10', 'uid3.uid4': '2'},
        'NEVER_SKIP',
      );
      expect(result, 5.0);
    });

    test('handles division by zero', () {
      final result = ExpressionEvaluator.evaluate(
        '#{uid1.uid2} / #{uid3.uid4}',
        {'uid1.uid2': '10', 'uid3.uid4': '0'},
        'NEVER_SKIP',
      );
      expect(result, 0.0);
    });

    test('evaluates complex expression with parentheses', () {
      final result = ExpressionEvaluator.evaluate(
        '(#{uid1.uid2} + #{uid3.uid4}) * 2',
        {'uid1.uid2': '3', 'uid3.uid4': '4'},
        'NEVER_SKIP',
      );
      expect(result, 14.0);
    });

    test('treats missing values as 0 with NEVER_SKIP', () {
      final result = ExpressionEvaluator.evaluate(
        '#{uid1.uid2} + #{uid3.uid4}',
        {'uid1.uid2': '5'},
        'NEVER_SKIP',
      );
      expect(result, 5.0);
    });

    test('evaluates literal number expression', () {
      final result = ExpressionEvaluator.evaluate(
        '#{uid1.uid2} * 1.5',
        {'uid1.uid2': '10'},
        'NEVER_SKIP',
      );
      expect(result, 15.0);
    });

    test('evaluates expression with multiple operations', () {
      final result = ExpressionEvaluator.evaluate(
        '#{a.b} + #{c.d} + #{e.f}',
        {'a.b': '1', 'c.d': '2', 'e.f': '3'},
        'NEVER_SKIP',
      );
      expect(result, 6.0);
    });

    test('handles empty string values as 0', () {
      final result = ExpressionEvaluator.evaluate(
        '#{uid1.uid2}',
        {'uid1.uid2': ''},
        'NEVER_SKIP',
      );
      expect(result, 0.0);
    });
  });
}
