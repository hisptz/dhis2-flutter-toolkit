import '../../../objectbox.g.dart';

import '../../models/metadata/program_rule_action.dart';
import 'base.dart';

/// This is a repository class for managing [D2ProgramRuleAction] entities.
///
/// This repository provides methods for retrieving and mapping program rule actions.
class D2ProgramRuleActionRepository
    extends BaseMetaRepository<D2ProgramRuleAction> {
  /// Constructs a [D2ProgramRuleActionRepository] with the provided database instance.
  ///
  /// - [db] The database instance.
  D2ProgramRuleActionRepository(super.db);

  /// Retrieves a [D2ProgramRuleAction] by its unique identifier (UID) [uid].
  ///
  /// - [uid] The unique identifier of the program rule action.
  ///
  /// Returns a [D2ProgramRuleAction] object if found, or `null` if not found.
  @override
  D2ProgramRuleAction? getByUid(String uid) {
    Query<D2ProgramRuleAction> query =
        box.query(D2ProgramRuleAction_.uid.equals(uid)).build();
    return query.findFirst();
  }

  /// Maps a JSON object [json] to a [D2ProgramRuleAction] entity.
  ///
  /// - [json] The JSON map containing program rule action data.
  ///
  /// Returns a [D2ProgramRuleAction] object constructed from the JSON data.
  @override
  D2ProgramRuleAction mapper(Map<String, dynamic> json) {
    return D2ProgramRuleAction.fromMap(db, json);
  }
}
