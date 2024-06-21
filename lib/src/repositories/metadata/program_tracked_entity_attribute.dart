import '../../../objectbox.g.dart';

import '../../models/metadata/program_tracked_entity_attribute.dart';
import 'base.dart';

/// This is a repository class for managing [D2ProgramTrackedEntityAttribute] entities.
///
/// This class extends [BaseMetaRepository] and provides methods for
/// querying and mapping [D2ProgramTrackedEntityAttribute] entities.
class D2ProgramTrackedEntityAttributeRepository
    extends BaseMetaRepository<D2ProgramTrackedEntityAttribute> {
  /// Creates a new instance of [D2ProgramTrackedEntityAttributeRepository].
  ///
  /// - [db] is the database instance.
  D2ProgramTrackedEntityAttributeRepository(super.db);

  /// Retrieves a [D2ProgramTrackedEntityAttribute] by its UID [uid].
  ///
  /// - [uid] is the unique identifier of the tracked entity attribute.
  ///
  /// Returns the corresponding [D2ProgramTrackedEntityAttribute], or null if not found.
  @override
  D2ProgramTrackedEntityAttribute? getByUid(String uid) {
    Query<D2ProgramTrackedEntityAttribute> query =
        box.query(D2ProgramTrackedEntityAttribute_.uid.equals(uid)).build();
    return query.findFirst();
  }

  /// Filters the repository by a specific program ID.
  ///
  /// - [programId] is the ID of the program.
  ///
  /// Returns the current instance of [ D2ProgramTrackedEntityAttributeRepository] with the applied filter.
  D2ProgramTrackedEntityAttributeRepository byProgram(int programId) {
    queryConditions =
        D2ProgramTrackedEntityAttribute_.program.equals(programId);
    return this;
  }

  /// Maps a JSON object to a [D2ProgramTrackedEntityAttribute].
  ///
  /// - [json] is the map containing the data to initialize the instance.
  ///
  /// Returns the corresponding [D2ProgramTrackedEntityAttribute].
  @override
  D2ProgramTrackedEntityAttribute mapper(Map<String, dynamic> json) {
    return D2ProgramTrackedEntityAttribute.fromMap(db, json);
  }
}
