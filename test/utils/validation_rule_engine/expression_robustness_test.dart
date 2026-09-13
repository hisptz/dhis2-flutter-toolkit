import 'package:dart_date/dart_date.dart';
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:flutter_test/flutter_test.dart';

double? _eval(String expression, [Map<String, String> dataValues = const {}]) {
  return ExpressionEvaluator.evaluate(expression, dataValues, 'NEVER_SKIP');
}

D2Period _makePeriod(DateTime start, DateTime end) {
  return D2Period.fromInterval(
    Interval(start, end),
    idGenerator: (Interval i) => 'test',
    nameGenerator: (Interval i) => 'Test period',
    type: 'Monthly',
    category: 'Fixed',
  );
}

void main() {
  group('malformed expressions never throw — they skip (return null)', () {
    test('unbalanced parentheses', () {
      expect(() => _eval('(((#{a.b}'), returnsNormally);
      expect(_eval('(((#{a.b}'), null);
    });

    test('unknown function name', () {
      expect(_eval('notARealFunction(#{a.b})'), null);
    });

    test('trailing operator / incomplete expression', () {
      expect(_eval('#{a.b} +'), null);
      expect(_eval('+'), null);
      expect(_eval(''), null);
    });

    test('empty function call where a value is required', () {
      expect(_eval('log()'), null);
      expect(_eval('isNull()'), null);
      expect(_eval('removeZeros()'), null);
      expect(_eval('containsItems()'), null);
    });

    test('wrong argument count for a fixed-arity function', () {
      // if() needs exactly 3 args. With only 2, the true-branch (args[1])
      // happens to exist, so a truthy condition "accidentally" resolves.
      expect(_eval('if(1,2)'), 2.0);
      // A falsy condition needs the missing args[2] (the false-branch) —
      // this must not crash the app; it should safely resolve to "no result".
      expect(() => _eval('if(0,2)'), returnsNormally);
      expect(_eval('if(0,2)'), null);
    });

    test('is() without the required "in" keyword', () {
      expect(_eval('is(#{a.b}, 1, 2)'), null);
    });

    test('orgUnit function given a quoted string instead of a bare UID', () {
      expect(_eval("orgUnit.ancestor('abc123XYZ01')"), null);
    });

    test('garbage / unexpected characters', () {
      expect(_eval('@@@ \$\$\$ %%%'), null);
      expect(_eval('#{a.b} § #{c.d}'), null);
    });

    test('a long run of unrecognized characters does not blow the stack', () {
      final garbage = List.filled(20000, '§').join();
      expect(() => _eval(garbage), returnsNormally);
      expect(_eval(garbage), null);
    });

    test('deeply nested parentheses do not blow the parser stack', () {
      const depth = 5000;
      final expr = '${'(' * depth}#{a.b}${')' * depth}';
      expect(() => _eval(expr, {'a.b': '5'}), returnsNormally);
    });

    test('null-argument functions with missing required args', () {
      expect(_eval('log10()'), null);
    });

    test('unterminated bracket literal at end of input', () {
      // The tokenizer reads bracket content up to `]` or end-of-input,
      // so a dropped trailing `]` still resolves as if it were closed —
      // lenient, but the important thing is it never crashes.
      final period = _makePeriod(
        DateTime(2024, 1, 1),
        DateTime(2024, 1, 31, 23, 59, 59, 999),
      );
      expect(() => _eval('#{a.b} / [days'), returnsNormally);
      expect(
        ExpressionEvaluator.evaluate(
          '#{a.b} / [days',
          {'a.b': '310'},
          'NEVER_SKIP',
          period: period,
        ),
        10.0,
      );
    });

    test('unterminated bracket literal followed by more input', () {
      expect(() => _eval('[days #{a.b}'), returnsNormally);
      expect(_eval('[days #{a.b}'), null);
    });

    test('empty bracket literal', () {
      expect(_eval('[]'), null);
    });

    test('unsupported bracket literal name', () {
      expect(_eval('[periodInYear]'), null);
      expect(_eval('[DAYS]'), null); // case-sensitive, unlike function names
    });

    test('malformed nested brackets', () {
      expect(() => _eval('[[days]]'), returnsNormally);
      expect(_eval('[[days]]'), null);
    });

    test('a period with end before start does not crash — just gives a nonsensical count', () {
      final backwards = _makePeriod(DateTime(2024, 2, 1), DateTime(2024, 1, 1));
      expect(
        () => ExpressionEvaluator.evaluate('[days]', {}, 'NEVER_SKIP', period: backwards),
        returnsNormally,
      );
    });

    test('very long content inside brackets does not hang or crash', () {
      final longBracket = '[${'x' * 20000}]';
      expect(() => _eval(longBracket), returnsNormally);
      expect(_eval(longBracket), null);
    });
  });
}
