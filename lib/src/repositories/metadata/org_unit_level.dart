import '../../../objectbox.g.dart';
import '../../models/metadata/org_unit_level.dart';
import 'base.dart';
import 'download_mixins/base_meta_download_mixin.dart';
import 'download_mixins/org_unit_level_download_mixin.dart';

/// This is a repository class for managing [D2OrgUnitLevel] entities.
class D2OrgUnitLevelRepository extends BaseMetaRepository<D2OrgUnitLevel>
    with
        BaseMetaDownloadServiceMixin<D2OrgUnitLevel>,
        D2OrgUnitLevelDownloadServiceMixin {
  /// Constructs a [D2OrgUnitLevelRepository].
  ///
  /// - [db] The database instance.
  D2OrgUnitLevelRepository(super.db);

  /// Retrieves a [D2OrgUnitLevel] by its unique UID [uid].
  ///
  /// - [uid] The unique UID of the organizational unit level.
  ///
  /// Returns the [D2OrgUnitLevel] with the specified UID, or null if not found.
  @override
  D2OrgUnitLevel? getByUid(String uid) {
    Query<D2OrgUnitLevel> query =
        box.query(D2OrgUnitLevel_.uid.equals(uid)).build();
    return query.findFirst();
  }

  /// Retrieves a [D2OrgUnitLevel] by its level.
  ///
  /// - [level] The level of the organizational unit.
  ///
  /// Returns the [D2OrgUnitLevel] with the specified level, or null if not found.
  D2OrgUnitLevel? getByLevel(int level) {
    Query<D2OrgUnitLevel> query =
        box.query(D2OrgUnitLevel_.level.equals(level)).build();
    return query.findFirst();
  }

  /// Maps a JSON object to a [D2OrgUnitLevel].
  ///
  /// - [json] The map containing the organizational unit level data.
  ///
  /// Returns a [D2OrgUnitLevel] instance.
  @override
  D2OrgUnitLevel mapper(Map<String, dynamic> json) {
    return D2OrgUnitLevel.fromMap(db, json);
  }
}
