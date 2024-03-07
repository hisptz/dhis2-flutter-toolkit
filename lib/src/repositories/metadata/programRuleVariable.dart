
import '../../../objectbox.g.dart';

import '../../models/metadata/programRuleVariable.dart';
import 'base.dart';

class D2ProgramRuleVariableRepository
    extends BaseMetaRepository<D2ProgramRuleVariable> {
  D2ProgramRuleVariableRepository(super.db);

  @override
  D2ProgramRuleVariable? getByUid(String uid) {
    Query<D2ProgramRuleVariable> query =
        box.query(D2ProgramRuleVariable_.uid.equals(uid)).build();
    return query.findFirst();
  }

  @override
  D2ProgramRuleVariable mapper(Map<String, dynamic> json) {
    return D2ProgramRuleVariable.fromMap(db, json);
  }
}
