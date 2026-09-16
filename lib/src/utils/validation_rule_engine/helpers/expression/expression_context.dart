import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:dhis2_flutter_toolkit/src/models/metadata/org_unit.dart';
import 'package:dhis2_flutter_toolkit/src/utils/period_engine/models/period.dart';

class D2ExpressionException implements Exception {
  final String message;

  const D2ExpressionException(this.message);

  @override
  String toString() => 'D2ExpressionException: $message';
}

class D2ExprEvalContext {
  final Map<String, String> dataValues;
  final D2OrgUnit? currentOrgUnit;
  final D2ObjectBox? db;
  final D2Period? period;

  final Map<String, bool>? orgUnitFunctionAnswers;

  bool replaceNulls = true;

  D2ExprEvalContext({
    required this.dataValues,
    this.currentOrgUnit,
    this.db,
    this.period,
    this.orgUnitFunctionAnswers,
  });
}
