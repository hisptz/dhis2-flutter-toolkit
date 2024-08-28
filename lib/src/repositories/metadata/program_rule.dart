import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';

import '../../../objectbox.g.dart';
import '../../models/metadata/program_rule.dart';
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

  @override
  Future<List<D2ProgramRule>> saveOffline(
      List<Map<String, dynamic>> json) async {
    String programUid = json.first["program"]["id"] as String;
    D2Program? program = D2ProgramRepository(db).getByUid(programUid);

    if (program != null) {
      List<D2ProgramRule> programRules = await box
          .query(D2ProgramRule_.program.equals(program.id))
          .build()
          .findAsync();

      List<int> ruleIds = programRules.map((rule) => rule.id).toList();
      List<int> ruleActionIds = [];
      for (D2ProgramRule rule in programRules) {
        List<int> programRuleActions =
            rule.programRuleActions.map((action) => action.id).toList();
        ruleActionIds.addAll(programRuleActions);
      }

      if (programRules.isNotEmpty) {
        await D2ProgramRuleActionRepository(db)
            .box
            .removeManyAsync(ruleActionIds);
        await box.removeManyAsync(ruleIds);
      }
    }

    return await super.saveOffline(json);
  }
}
