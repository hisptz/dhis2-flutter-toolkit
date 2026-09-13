import 'package:dart_date/dart_date.dart';
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:flutter_test/flutter_test.dart';

D2Period _makePeriod(DateTime start, DateTime end) {
  return D2Period.fromInterval(
    Interval(start, end),
    idGenerator: (Interval i) => 'test',
    nameGenerator: (Interval i) => 'Test period',
    type: 'Monthly',
    category: 'Fixed',
  );
}

double? _eval(String expression, [Map<String, String> dataValues = const {}]) {
  return ExpressionEvaluator.evaluate(expression, dataValues, 'NEVER_SKIP');
}

void main() {
  group('contains', () {
    test('true when every substring is present', () {
      expect(_eval("contains(#{a.b}, 'ab', 'bc')", {'a.b': 'abcd'}), 1.0);
    });

    test('false when any substring is missing (case-sensitive)', () {
      expect(_eval("contains(#{a.b}, 'ab', 'zz')", {'a.b': 'abcd'}), 0.0);
      expect(_eval("contains(#{a.b}, 'AB')", {'a.b': 'abcd'}), 0.0);
    });
  });

  group('containsItems', () {
    test('true when every item exactly matches a list element', () {
      expect(_eval("containsItems(#{a.b}, 'B')", {'a.b': 'A,B,C'}), 1.0);
    });

    test('false for a substring that is not an exact item', () {
      // Differs from contains: "b" is not an exact element of "A,B,C".
      expect(_eval("containsItems(#{a.b}, 'b')", {'a.b': 'A,B,C'}), 0.0);
      expect(_eval("containsItems(#{a.b}, 'AB')", {'a.b': 'abcd'}), 0.0);
    });
  });

  group('if', () {
    test('returns the true branch when condition holds', () {
      expect(_eval('if(#{a.b} > 5, 1, 2)', {'a.b': '10'}), 1.0);
    });

    test('returns the false branch when condition does not hold', () {
      expect(_eval('if(#{a.b} > 5, 1, 2)', {'a.b': '3'}), 2.0);
    });

    test('only evaluates the taken branch', () {
      // The untaken branch's `null` literal must not disable defaulting.
      expect(_eval('if(#{a.b} > 0, 1, null)', {'a.b': '5'}), 1.0);
    });
  });

  group('is', () {
    test('true when the value matches a candidate', () {
      expect(_eval('is(#{a.b} in 1,2,3)', {'a.b': '2'}), 1.0);
    });

    test('false when the value matches no candidate', () {
      expect(_eval('is(#{a.b} in 1,2,3)', {'a.b': '5'}), 0.0);
    });
  });

  group('isNull / isNotNull', () {
    test('isNull is true for a genuinely missing value', () {
      expect(_eval('isNull(#{a.b})', {}), 1.0);
    });

    test('isNull is false for a value explicitly recorded as zero', () {
      // The key distinction: a present "0" is not the same as missing.
      expect(_eval('isNull(#{a.b})', {'a.b': '0'}), 0.0);
    });

    test('isNotNull mirrors isNull', () {
      expect(_eval('isNotNull(#{a.b})', {'a.b': '0'}), 1.0);
      expect(_eval('isNotNull(#{a.b})', {}), 0.0);
    });
  });

  group('firstNonNull', () {
    test('returns the first genuinely non-null argument', () {
      expect(
        _eval('firstNonNull(#{a.b}, #{c.d})', {'c.d': '7'}),
        7.0,
      );
    });

    test('falls through to a literal default', () {
      expect(_eval('firstNonNull(#{a.b}, 9)', {}), 9.0);
    });

    test('defaults to 0 at the top level when every argument is null', () {
      // firstNonNull's internal null doesn't leak replaceNulls=false,
      // so the overall expression still defaults to 0.
      expect(_eval('firstNonNull(#{a.b})', {}), 0.0);
    });
  });

  group('greatest / least', () {
    test('greatest picks the highest value', () {
      expect(_eval('greatest(#{a.b}, #{c.d}, 9)', {'a.b': '3', 'c.d': '7'}), 9.0);
    });

    test('least picks the lowest value', () {
      expect(_eval('least(#{a.b}, #{c.d}, 1)', {'a.b': '3', 'c.d': '7'}), 1.0);
    });

    test('null arguments are skipped once a real value is found', () {
      expect(_eval('greatest(null, 5, 2)'), 5.0);
    });

    test('result is "no result" when every argument is null', () {
      expect(_eval('greatest(null, null)'), null);
    });
  });

  group('log / log10', () {
    test('log with one argument is natural log', () {
      final result = _eval('log(#{a.b})', {'a.b': '7.38905609893065'});
      expect(result, closeTo(2.0, 1e-9));
    });

    test('log with a base argument uses change of base', () {
      expect(_eval('log(#{a.b}, 2)', {'a.b': '8'}), closeTo(3.0, 1e-9));
    });

    test('log10', () {
      expect(_eval('log10(#{a.b})', {'a.b': '1000'}), closeTo(3.0, 1e-9));
    });
  });

  group('null literal', () {
    test('produces no result and stops defaulting for the rest of the expression', () {
      expect(_eval('if(#{a.b} > 0, null, 1)', {'a.b': '5'}), null);
    });

    test('untaken branch does not affect the result', () {
      expect(_eval('if(#{a.b} > 0, null, 1)', {'a.b': '-5'}), 1.0);
    });
  });

  group('removeZeros', () {
    test('passes non-zero values through unchanged', () {
      expect(_eval('removeZeros(#{a.b})', {'a.b': '5'}), 5.0);
    });

    test('collapses an explicit zero to "no result"', () {
      expect(_eval('removeZeros(#{a.b})', {'a.b': '0'}), null);
    });

    test('collapses a missing (defaulted-to-zero) value the same way', () {
      expect(_eval('removeZeros(#{a.b})', {}), null);
    });
  });

  group('[days]', () {
    test('daysInPeriod is inclusive of both the start and end date', () {
      final january = _makePeriod(
        DateTime(2024, 1, 1),
        DateTime(2024, 1, 31, 23, 59, 59, 999),
      );
      expect(january.daysInPeriod, 31);

      final daily = _makePeriod(
        DateTime(2024, 1, 1),
        DateTime(2024, 1, 1, 23, 59, 59, 999),
      );
      expect(daily.daysInPeriod, 1);

      final isoWeek = _makePeriod(
        DateTime(2024, 1, 1),
        DateTime(2024, 1, 7, 23, 59, 59, 999),
      );
      expect(isoWeek.daysInPeriod, 7);
    });

    test('is null when the period has no start/end', () {
      final period = _makePeriod(DateTime(2024), DateTime(2024));
      period.start = null;
      period.end = null;
      expect(period.daysInPeriod, null);
    });

    test('[days] evaluates to the number of days in the given period', () {
      final january = _makePeriod(
        DateTime(2024, 1, 1),
        DateTime(2024, 1, 31, 23, 59, 59, 999),
      );
      expect(
        ExpressionEvaluator.evaluate('[days]', {}, 'NEVER_SKIP', period: january),
        31.0,
      );
    });

    test('a data value can be normalized into a daily rate', () {
      final january = _makePeriod(
        DateTime(2024, 1, 1),
        DateTime(2024, 1, 31, 23, 59, 59, 999),
      );
      expect(
        ExpressionEvaluator.evaluate(
          '#{a.b} / [days]',
          {'a.b': '310'},
          'NEVER_SKIP',
          period: january,
        ),
        10.0,
      );
    });

    test('defaults to 0 (not a crash) when no period is supplied', () {
      expect(ExpressionEvaluator.evaluate('[days]', {}, 'NEVER_SKIP'), 0.0);
    });

    test('rejects unsupported bracket literals rather than crashing', () {
      expect(
        ExpressionEvaluator.evaluate('[periodInYear]', {}, 'NEVER_SKIP'),
        null,
      );
    });
  });

  group('orgUnit.* functions', () {
    late D2ObjectBox db;

    setUpAll(() async {
      db = await D2ObjectBox.createTest();
    });

    D2OrgUnit makeOrgUnit(String uid, String path) {
      final now = DateTime.now();
      final orgUnit = D2OrgUnit(
        0,
        uid,
        uid,
        uid,
        uid,
        path,
        now,
        now,
        now,
        null,
      );
      final id = db.store.box<D2OrgUnit>().put(orgUnit);
      orgUnit.id = id;
      return orgUnit;
    }

    test('orgUnit.ancestor is true only for strict descendants', () {
      final descendant = makeOrgUnit('descend01A', '/root0000001/descend01A');

      expect(
        ExpressionEvaluator.evaluate(
          'orgUnit.ancestor(root0000001)',
          {},
          'NEVER_SKIP',
          currentOrgUnit: descendant,
        ),
        1.0,
      );

      // The org unit is never its own ancestor.
      expect(
        ExpressionEvaluator.evaluate(
          'orgUnit.ancestor(descend01A)',
          {},
          'NEVER_SKIP',
          currentOrgUnit: descendant,
        ),
        0.0,
      );
    });

    test('orgUnit.dataSet checks direct assignment', () {
      final orgUnit = makeOrgUnit('facility01A', '/root0000001/facility01A');
      final otherOrgUnit =
          makeOrgUnit('facility02B', '/root0000001/facility02B');

      final now = DateTime.now();
      final dataSet = D2DataSet(
        0,
        'DS',
        now,
        'Data Set',
        null,
        now,
        'Monthly',
        0,
        0,
        'dataset001A',
        0,
        0,
        false,
        false,
        false,
      );
      dataSet.organisationUnits.add(orgUnit);
      final dsId = db.store.box<D2DataSet>().put(dataSet);
      dataSet.id = dsId;

      expect(
        ExpressionEvaluator.evaluate(
          'orgUnit.dataSet(dataset001A)',
          {},
          'NEVER_SKIP',
          currentOrgUnit: orgUnit,
          db: db,
        ),
        1.0,
      );
      expect(
        ExpressionEvaluator.evaluate(
          'orgUnit.dataSet(dataset001A)',
          {},
          'NEVER_SKIP',
          currentOrgUnit: otherOrgUnit,
          db: db,
        ),
        0.0,
      );
    });

    test('orgUnit.group checks membership', () {
      final orgUnit = makeOrgUnit('facility03C', '/root0000001/facility03C');

      final now = DateTime.now();
      final group = D2OrgUnitGroup(0, 'Group', 'Group', 'group0001A', now, now);
      group.organisationUnits.add(orgUnit);
      final groupId = db.store.box<D2OrgUnitGroup>().put(group);
      group.id = groupId;

      expect(
        ExpressionEvaluator.evaluate(
          'orgUnit.group(group0001A)',
          {},
          'NEVER_SKIP',
          currentOrgUnit: orgUnit,
          db: db,
        ),
        1.0,
      );
    });

    test('orgUnit.program checks assignment', () {
      final orgUnit = makeOrgUnit('facility04D', '/root0000001/facility04D');

      final now = DateTime.now();
      final program = D2Program(
        now,
        now,
        'program001',
        'NONE',
        'Program',
        null,
        'Program',
        'WITHOUT_REGISTRATION',
        null,
        'Program',
        'PRG',
        null,
        null,
      );
      program.organisationUnits.add(orgUnit);
      final programId = db.store.box<D2Program>().put(program);
      program.id = programId;

      expect(
        ExpressionEvaluator.evaluate(
          'orgUnit.program(program001)',
          {},
          'NEVER_SKIP',
          currentOrgUnit: orgUnit,
          db: db,
        ),
        1.0,
      );
    });

    test('orgUnit.* functions default to false without a currentOrgUnit', () {
      expect(
        ExpressionEvaluator.evaluate(
          'orgUnit.ancestor(root0000001)',
          {},
          'NEVER_SKIP',
        ),
        0.0,
      );
    });
  });
}
