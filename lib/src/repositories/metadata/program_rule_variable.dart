import '../../../objectbox.g.dart';

import '../../models/metadata/program_rule_variable.dart';
import 'base.dart';

/// This is a repository class for managing [D2ProgramRuleVariable] instances.
///
/// This class extends [BaseMetaRepository] and provides methods to query and map
/// [D2ProgramRuleVariable] objects from the database.
class D2ProgramRuleVariableRepository
    extends BaseMetaRepository<D2ProgramRuleVariable> {
  /// Constructs a [D2ProgramRuleVariableRepository].
  ///
  /// - [db] The [D2ObjectBox] instance used for repository operations.
  D2ProgramRuleVariableRepository(super.db);

  /// Retrieves a [D2ProgramRuleVariable] by its unique identifier [uid].
  ///
  /// - [uid] The unique identifier of the program rule variable.
  ///
  /// Returns a [D2ProgramRuleVariable] instance with the specified UID, or `null` if not found.
  @override
  D2ProgramRuleVariable? getByUid(String uid) {
    Query<D2ProgramRuleVariable> query =
        box.query(D2ProgramRuleVariable_.uid.equals(uid)).build();
    return query.findFirst();
  }

  /// Maps a JSON object [json] to a [D2ProgramRuleVariable] instance.
  ///
  /// - [json] The JSON object containing the program rule variable data.
  ///
  /// Returns a [D2ProgramRuleVariable] instance created from the JSON data.
  @override
  D2ProgramRuleVariable mapper(Map<String, dynamic> json) {
    return D2ProgramRuleVariable.fromMap(db, json);
  }
}
