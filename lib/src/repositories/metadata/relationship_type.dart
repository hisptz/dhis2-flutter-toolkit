import '../../../objectbox.g.dart';

import '../../models/metadata/relationship_type.dart';
import 'base.dart';
import 'download_mixins/base_meta_download_mixin.dart';
import 'download_mixins/relationship_type_download_mixin.dart';

/// This is a repository class for managing [D2RelationshipType] entities.
///
/// This class extends [BaseMetaRepository] and includes mixins
/// [BaseMetaDownloadServiceMixin] and [D2RelationshipTypeDownloadMixin]
/// to provide additional functionalities related to metadata download.
class D2RelationshipTypeRepository
    extends BaseMetaRepository<D2RelationshipType>
    with
        BaseMetaDownloadServiceMixin<D2RelationshipType>,
        D2RelationshipTypeDownloadMixin {
  /// Constructs a [D2RelationshipTypeRepository] instance.
  ///
  /// - [db] is the instance of [D2ObjectBox] used for database operations.
  D2RelationshipTypeRepository(super.db);

  /// Retrieves a [D2RelationshipType] by its unique identifier.
  ///
  /// - [uid] is the unique identifier of the [D2RelationshipType].
  ///
  /// Returns the [D2RelationshipType] if found, otherwise returns null.
  @override
  D2RelationshipType? getByUid(String uid) {
    Query<D2RelationshipType> query =
        box.query(D2RelationshipType_.uid.equals(uid)).build();
    return query.findFirst();
  }

  /// Maps a JSON object to a [D2RelationshipType] instance.
  ///
  /// - [json] is the map containing the relationship type data.
  ///
  /// Returns the [D2RelationshipType] instance created from the JSON data.
  @override
  D2RelationshipType mapper(Map<String, dynamic> json) {
    return D2RelationshipType.fromMap(db, json);
  }
}
