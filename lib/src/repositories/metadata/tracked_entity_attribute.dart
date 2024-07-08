import '../../../objectbox.g.dart';

import '../../models/metadata/tracked_entity_attribute.dart';
import 'base.dart';

/// This is a repository class for managing [D2TrackedEntityAttribute] instances.
///
/// This repository provides methods for querying and mapping tracked entity attributes
/// from the database.
class D2TrackedEntityAttributeRepository
    extends BaseMetaRepository<D2TrackedEntityAttribute> {
  /// Constructs a new [D2TrackedEntityAttributeRepository] with the provided database instance.
  D2TrackedEntityAttributeRepository(super.db);

  /// Retrieves a [D2TrackedEntityAttribute] by its unique identifier (UID) [uid].
  ///
  /// - [uid] The unique identifier of the tracked entity attribute.
  ///
  /// Returns the [D2TrackedEntityAttribute] if found, otherwise null.
  @override
  D2TrackedEntityAttribute? getByUid(String uid) {
    Query<D2TrackedEntityAttribute> query =
        box.query(D2TrackedEntityAttribute_.uid.equals(uid)).build();

    return query.findFirst();
  }

  /// Retrieves the ID of a [D2TrackedEntityAttribute] by its unique identifier (UID) [uid].
  ///
  /// - [uid] The unique identifier of the tracked entity attribute.
  ///
  /// Returns the ID of the [D2TrackedEntityAttribute] if found, otherwise null.
  @override
  int? getIdByUid(String uid) {
    return getByUid(uid)?.id;
  }

  /// Maps a JSON object to a [D2TrackedEntityAttribute] instance.
  ///
  /// - [json] The JSON object containing attribute data.
  ///
  /// Returns a [D2TrackedEntityAttribute] instance mapped from the JSON object.
  @override
  D2TrackedEntityAttribute mapper(Map<String, dynamic> json) {
    return D2TrackedEntityAttribute.fromMap(db, json);
  }
}
