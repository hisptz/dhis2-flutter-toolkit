import '../../../objectbox.g.dart';

import '../../models/metadata/tracked_entity_type_attribute.dart';
import 'base.dart';

/// This is a repository class for managing [D2TrackedEntityTypeAttribute] entities.
///
/// This class provides methods for querying and mapping [D2TrackedEntityTypeAttribute] entities
/// from the database.
class D2TrackedEntityTypeAttributeRepository
    extends BaseMetaRepository<D2TrackedEntityTypeAttribute> {
  /// Constructs a new [D2TrackedEntityTypeAttributeRepository].
  ///
  /// - [db] The database instance.
  D2TrackedEntityTypeAttributeRepository(super.db);

  /// Retrieves a [D2TrackedEntityTypeAttribute] by its UID [uid].
  ///
  /// - [uid] The UID of the tracked entity type attribute.
  ///
  /// Returns the [D2TrackedEntityTypeAttribute] with the specified UID, or `null` if not found.
  @override
  D2TrackedEntityTypeAttribute? getByUid(String uid) {
    Query<D2TrackedEntityTypeAttribute> query =
        box.query(D2TrackedEntityTypeAttribute_.uid.equals(uid)).build();
    return query.findFirst();
  }

  /// Maps a JSON object to a [D2TrackedEntityTypeAttribute].
  ///
  /// - [json] The JSON object containing tracked entity type attribute data.
  ///
  /// Returns the [D2TrackedEntityTypeAttribute] created from the JSON object.
  @override
  D2TrackedEntityTypeAttribute mapper(Map<String, dynamic> json) {
    return D2TrackedEntityTypeAttribute.fromMap(db, json);
  }
}
