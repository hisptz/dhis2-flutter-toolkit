import '../../../objectbox.g.dart';

import '../../models/metadata/org_unit_group.dart';
import 'base.dart';
import 'download_mixins/base_meta_download_mixin.dart';
import 'download_mixins/org_unit_group_download_mixin.dart';

/// This is a repository class for managing and accessing [D2OrgUnitGroup] entities.
class D2OrgUnitGroupRepository extends BaseMetaRepository<D2OrgUnitGroup>
    with
        BaseMetaDownloadServiceMixin<D2OrgUnitGroup>,
        D2OrgUnitGroupDownloadServiceMixin {
  /// Constructs a [D2OrgUnitGroupRepository].
  ///
  /// - [db] The [D2ObjectBox] instance.
  D2OrgUnitGroupRepository(super.db);

  /// Retrieves a [D2OrgUnitGroup] by its unique identifier [uid].
  ///
  /// - [uid] The unique identifier string (UID) of the organizational unit group.
  ///
  /// Returns a [D2OrgUnitGroup] instance, or `null` if not found.
  @override
  D2OrgUnitGroup? getByUid(String uid) {
    Query<D2OrgUnitGroup> query =
        box.query(D2OrgUnitGroup_.uid.equals(uid)).build();

    return query.findFirst();
  }

  /// Maps a JSON object [json] to a [D2OrgUnitGroup] entity.
  ///
  /// - [json] The JSON map containing organizational unit group data.
  ///
  /// Returns a [D2OrgUnitGroup] instance created from the JSON map.
  @override
  D2OrgUnitGroup mapper(Map<String, dynamic> json) {
    return D2OrgUnitGroup.fromMap(db, json);
  }
}
