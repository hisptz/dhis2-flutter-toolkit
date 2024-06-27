import '../../../objectbox.g.dart';
import '../../models/metadata/org_unit.dart';
import 'base.dart';
import 'download_mixins/base_meta_download_mixin.dart';
import 'download_mixins/org_unit_download_mixin.dart';

/// This is a repository class for managing [D2OrgUnit] entities.
///
/// Extends [BaseMetaRepository] and mixes in [BaseMetaDownloadServiceMixin]
/// and [D2OrgUnitDownloadServiceMixin] for additional functionality.
class D2OrgUnitRepository extends BaseMetaRepository<D2OrgUnit>
    with
        BaseMetaDownloadServiceMixin<D2OrgUnit>,
        D2OrgUnitDownloadServiceMixin {
  /// Constructs a [D2OrgUnitRepository] instance with the given database.
  D2OrgUnitRepository(super.db);

  /// Gets the ID of an organization unit by its UID [uid].
  ///
  /// Returns the ID as an [int], or `null` if not found.
  @override
  int? getIdByUid(String uid) {
    return getByUid(uid)?.id;
  }

  /// Asynchronously gets a list of organization units by their level [level].
  ///
  /// - [level] The organization unit level
  ///
  /// Returns a [Future] that completes with a list of [D2OrgUnit].
  Future<List<D2OrgUnit>> getByLevel(int level) async {
    QueryBuilder<D2OrgUnit> queryBuilder = box.query();
    queryBuilder.link(D2OrgUnit_.level, D2OrgUnitLevel_.level.equals(level));
    return queryBuilder.build().findAsync();
  }

  /// Gets an organization unit by its UID [uid].
  ///
  /// Returns the [D2OrgUnit] instance or `null` if not found.
  @override
  D2OrgUnit? getByUid(String uid) {
    Query<D2OrgUnit> query = box.query(D2OrgUnit_.uid.equals(uid)).build();
    return query.findFirst();
  }

  /// Maps a JSON object to a [D2OrgUnit] instance.
  ///
  /// - [json] The JSON map containing organization unit data.
  ///
  /// Returns a instance of [D2OrgUnit].
  @override
  D2OrgUnit mapper(Map<String, dynamic> json) {
    return D2OrgUnit.fromMap(db, json);
  }
}
