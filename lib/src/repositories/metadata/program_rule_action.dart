import '../../../objectbox.g.dart';

import '../../models/metadata/program_rule_action.dart';
import 'base.dart';

class D2ProgramRuleActionRepository
    extends BaseMetaRepository<D2ProgramRuleAction> {
  D2ProgramRuleActionRepository(super.db);

  @override
  D2ProgramRuleAction? getByUid(String uid) {
    Query<D2ProgramRuleAction> query =
        box.query(D2ProgramRuleAction_.uid.equals(uid)).build();
    return query.findFirst();
  }

  @override
  D2ProgramRuleAction mapper(Map<String, dynamic> json) {
    return D2ProgramRuleAction.fromMap(db, json);
  }
}
