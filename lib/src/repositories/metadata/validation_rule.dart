import '../../../objectbox.g.dart';
import '../../models/metadata/validation_rule.dart';
import './base.dart';

class D2ValidationRuleRepository extends BaseMetaRepository<D2ValidationRule> {
  D2ValidationRuleRepository(super.db);

  @override
  D2ValidationRule? getByUid(String uid) {
    Query<D2ValidationRule> query =
        box.query(D2ValidationRule_.uid.equals(uid)).build();
    return query.findFirst();
  }

  @override
  D2ValidationRule mapper(Map<String, dynamic> json) {
    return D2ValidationRule.fromMap(db, json);
  }

  List<D2ValidationRule> getByDataSet(String dataSetUid) {
    final all = box.getAll();
    return all
        .where((rule) => rule.dataSets.any((ds) => ds.uid == dataSetUid))
        .toList();
  }

  List<D2ValidationRule> getFormValidationRules(String dataSetUid) {
    return getByDataSet(dataSetUid)
        .where((rule) => !rule.skipFormValidation)
        .toList();
  }
}
