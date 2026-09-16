import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:flutter_test/flutter_test.dart';

D2ValidationRule _makeRule({
  String uid = 'rule1',
  String operator = 'less_than_or_equal_to',
  bool skipFormValidation = false,
  String leftSideExpression = '#{uid1.uid2}',
  String leftSideMissingValueStrategy = 'SKIP_IF_ALL_VALUES_MISSING',
  String rightSideExpression = '#{uid3.uid4}',
  String rightSideMissingValueStrategy = 'SKIP_IF_ALL_VALUES_MISSING',
}) {
  return D2ValidationRule(
    0,
    uid,
    DateTime.now(),
    DateTime.now(),
    'Test Rule',
    null,
    null,
    'MEDIUM',
    operator,
    null,
    skipFormValidation,
    leftSideExpression,
    null,
    leftSideMissingValueStrategy,
    false,
    rightSideExpression,
    null,
    rightSideMissingValueStrategy,
    false,
  );
}

void main() {
  group('D2ValidationRuleEngine.validateInIsolate', () {
    test(
      'produces the same violations as the synchronous validate()',
      () async {
        final rules = [
          _makeRule(uid: 'r1', operator: 'less_than_or_equal_to'),
          _makeRule(
            uid: 'r2',
            operator: 'equal_to',
            leftSideExpression: '#{a.b}',
            rightSideExpression: '#{c.d}',
          ),
        ];
        final engine = D2ValidationRuleEngine(validationRules: rules);
        final dataValues = {
          'uid1.uid2': '15',
          'uid3.uid4': '10',
          'a.b': '5',
          'c.d': '5',
        };

        final syncResult = engine.validate(dataValues);
        final isolateResult = await engine.validateInIsolate(dataValues);

        expect(isolateResult.violations.length, syncResult.violations.length);
        expect(isolateResult.violations.length, 1);
        expect(isolateResult.violations.first.rule.uid, 'r1');
        expect(
          isolateResult.violations.first.leftSideValue,
          syncResult.violations.first.leftSideValue,
        );
        expect(
          isolateResult.violations.first.rightSideValue,
          syncResult.violations.first.rightSideValue,
        );
        // The returned violation's rule is the actual object from the
        // engine's own rule list, not a detached copy.
        expect(identical(isolateResult.violations.first.rule, rules[0]), true);
      },
    );

    test('skipFormValidation rules never reach the isolate', () async {
      final rule = _makeRule(operator: 'equal_to', skipFormValidation: true);
      final engine = D2ValidationRuleEngine(validationRules: [rule]);

      final result = await engine.validateInIsolate({
        'uid1.uid2': '5',
        'uid3.uid4': '10',
      });

      expect(result.hasViolations, false);
    });

    test(
      'function-based rules with no #{} operands run for real (not silently skipped)',
      () async {
        final rule = _makeRule(
          operator: 'less_than',
          leftSideExpression: 'greatest(#{a.b}, #{c.d})',
          leftSideMissingValueStrategy: 'NEVER_SKIP',
          rightSideExpression: '100',
          rightSideMissingValueStrategy: 'NEVER_SKIP',
        );
        final engine = D2ValidationRuleEngine(validationRules: [rule]);

        // 70 < 100 — passes, no violation.
        final passingResult = await engine.validateInIsolate({
          'a.b': '30',
          'c.d': '70',
        });
        expect(passingResult.hasViolations, false);
        expect(
          engine.validate({'a.b': '30', 'c.d': '70'}).hasViolations,
          false,
        );

        // 130 is not < 100 — must actually fire, proving this ran real
        // evaluation rather than being silently skipped.
        final failingResult = await engine.validateInIsolate({
          'a.b': '30',
          'c.d': '130',
        });
        expect(failingResult.hasViolations, true);
        expect(failingResult.violations.first.leftSideValue, 130.0);
      },
    );

    group(
      'orgUnit.* functions — answers pre-fetched, evaluation stays in the isolate',
      () {
        late D2ObjectBox db;
        late D2OrgUnit orgUnit;
        late D2DataSet dataSet;

        setUpAll(() async {
          db = await D2ObjectBox.createTest();
          final now = DateTime.now();
          orgUnit = D2OrgUnit(
            0,
            'facility01A',
            'facility01A',
            'facility01A',
            'facility01A',
            '/root0000001/facility01A',
            now,
            now,
            now,
            null,
          );
          final ouId = db.store.box<D2OrgUnit>().put(orgUnit);
          orgUnit.id = ouId;

          dataSet = D2DataSet(
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
        });

        test(
          'a true orgUnit.ancestor() answer resolves correctly through the isolate',
          () async {
            final rule = _makeRule(
              operator: 'equal_to',
              leftSideExpression: 'if(orgUnit.ancestor(root0000001), 1, 0)',
              leftSideMissingValueStrategy: 'NEVER_SKIP',
              rightSideExpression: '1',
              rightSideMissingValueStrategy: 'NEVER_SKIP',
            );
            final engine = D2ValidationRuleEngine(validationRules: [rule]);

            final result = await engine.validateInIsolate(
              {},
              currentOrgUnit: orgUnit,
              db: db,
            );

            expect(result.hasViolations, false);
          },
        );

        test(
          'a false orgUnit.ancestor() answer resolves correctly through the isolate',
          () async {
            final rule = _makeRule(
              operator: 'equal_to',
              leftSideExpression: 'if(orgUnit.ancestor(otherRoot01), 1, 0)',
              leftSideMissingValueStrategy: 'NEVER_SKIP',
              rightSideExpression: '1',
              rightSideMissingValueStrategy: 'NEVER_SKIP',
            );
            final engine = D2ValidationRuleEngine(validationRules: [rule]);

            final result = await engine.validateInIsolate(
              {},
              currentOrgUnit: orgUnit,
              db: db,
            );

            expect(result.hasViolations, true);
            expect(result.violations.first.leftSideValue, 0.0);
          },
        );

        test(
          'orgUnit.dataSet() — a DB-backed answer also resolves correctly through the isolate',
          () async {
            final rule = _makeRule(
              operator: 'equal_to',
              leftSideExpression: 'if(orgUnit.dataSet(dataset001A), 1, 0)',
              leftSideMissingValueStrategy: 'NEVER_SKIP',
              rightSideExpression: '1',
              rightSideMissingValueStrategy: 'NEVER_SKIP',
            );
            final engine = D2ValidationRuleEngine(validationRules: [rule]);

            final result = await engine.validateInIsolate(
              {},
              currentOrgUnit: orgUnit,
              db: db,
            );

            expect(result.hasViolations, false);
          },
        );

        test(
          'multiple rules sharing the same orgUnit.* reference only resolve it once',
          () async {
            final rules = [
              _makeRule(
                uid: 'r1',
                operator: 'equal_to',
                leftSideExpression: 'if(orgUnit.ancestor(root0000001), 1, 0)',
                leftSideMissingValueStrategy: 'NEVER_SKIP',
                rightSideExpression: '1',
                rightSideMissingValueStrategy: 'NEVER_SKIP',
              ),
              _makeRule(
                uid: 'r2',
                operator: 'equal_to',
                leftSideExpression: 'if(orgUnit.ancestor(root0000001), 5, 0)',
                leftSideMissingValueStrategy: 'NEVER_SKIP',
                rightSideExpression: '5',
                rightSideMissingValueStrategy: 'NEVER_SKIP',
              ),
            ];
            final engine = D2ValidationRuleEngine(validationRules: rules);

            final result = await engine.validateInIsolate(
              {},
              currentOrgUnit: orgUnit,
              db: db,
            );

            expect(result.hasViolations, false);
          },
        );

        test(
          'matches the synchronous validate() result for the same rule',
          () async {
            final rule = _makeRule(
              operator: 'equal_to',
              leftSideExpression: 'if(orgUnit.ancestor(root0000001), 1, 0)',
              leftSideMissingValueStrategy: 'NEVER_SKIP',
              rightSideExpression: '1',
              rightSideMissingValueStrategy: 'NEVER_SKIP',
            );
            final engine = D2ValidationRuleEngine(validationRules: [rule]);

            final syncResult = engine.validate(
              {},
              currentOrgUnit: orgUnit,
              db: db,
            );
            final isolateResult = await engine.validateInIsolate(
              {},
              currentOrgUnit: orgUnit,
              db: db,
            );

            expect(isolateResult.hasViolations, syncResult.hasViolations);
          },
        );
      },
    );
  });
}
