
import '../../../objectbox.g.dart';

import '../../models/metadata/programRule.dart';
import 'base.dart';

class D2ProgramRuleRepository extends BaseMetaRepository<D2ProgramRule> {
  D2ProgramRuleRepository(super.db);

  @override
  D2ProgramRule? getByUid(String uid) {
    Query<D2ProgramRule> query =
        box.query(D2ProgramRule_.uid.equals(uid)).build();
    return query.findFirst();
  }

  @override
  D2ProgramRule mapper(Map<String, dynamic> json) {
    return D2ProgramRule.fromMap(db, json);
  }
}
