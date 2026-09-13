import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:dhis2_flutter_toolkit/src/models/metadata/org_unit.dart';
import 'package:dhis2_flutter_toolkit/src/utils/period_engine/models/period.dart';

import 'expression/expression_context.dart';
import 'expression/expression_parser.dart';
import 'expression/expression_value_utils.dart';

class ExpressionEvaluator {
  static final RegExp _operandPattern = RegExp(r'#\{([^}]+)\}');

  static List<String> extractOperands(String expression) {
    return _operandPattern
        .allMatches(expression)
        .map((m) => m.group(1)!)
        .toList();
  }

  static double? evaluate(
    String expression,
    Map<String, String> dataValues,
    String missingValueStrategy, {
    D2OrgUnit? currentOrgUnit,
    D2ObjectBox? db,
    D2Period? period,
  }) {
    try {
      final node = D2ExpressionParser(expression).parse();
      final ctx = D2ExprEvalContext(
        dataValues: dataValues,
        currentOrgUnit: currentOrgUnit,
        db: db,
        period: period,
      );

      final result = node.eval(ctx);
      final asDouble = d2CastDouble(result);
      if (asDouble != null) return asDouble;

      return ctx.replaceNulls ? 0.0 : null;
    } catch (e) {
      return null;
    }
  }
}
