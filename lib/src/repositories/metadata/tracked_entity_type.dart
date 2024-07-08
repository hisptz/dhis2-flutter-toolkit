import '../../../objectbox.g.dart';

import '../../models/metadata/tracked_entity_type.dart';
import 'base.dart';
import 'download_mixins/base_meta_download_mixin.dart';
import 'download_mixins/tracked_entity_type_download_mixin.dart';

/// This is a repository class for managing [D2TrackedEntityType] entities.
///
/// This class provides methods for querying and mapping [D2TrackedEntityType] entities
/// from the database.
class D2TrackedEntityTypeRepository
    extends BaseMetaRepository<D2TrackedEntityType>
    with
        BaseMetaDownloadServiceMixin<D2TrackedEntityType>,
        D2TrackedEntityTypeDownloadServiceMixin {
  /// Constructs a new [D2TrackedEntityTypeRepository].
  ///
  /// - [db] The database instance.
  D2TrackedEntityTypeRepository(super.db);

  /// Retrieves a [D2TrackedEntityType] by its UID [uid].
  ///
  /// - [uid] The UID of the tracked entity type.
  ///
  /// Returns The [D2TrackedEntityType] with the specified UID, or `null` if not found.
  @override
  D2TrackedEntityType? getByUid(String uid) {
    Query<D2TrackedEntityType> query =
        box.query(D2TrackedEntityType_.uid.equals(uid)).build();
    return query.findFirst();
  }

  /// Maps a JSON object to a [D2TrackedEntityType].
  ///
  /// - [json] The JSON object containing tracked entity type data.
  ///
  /// Returns the [D2TrackedEntityType] created from the JSON object.
  @override
  D2TrackedEntityType mapper(Map<String, dynamic> json) {
    return D2TrackedEntityType.fromMap(db, json);
  }
}
