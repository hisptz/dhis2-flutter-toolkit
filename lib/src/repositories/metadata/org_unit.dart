import '../../../objectbox.g.dart';
import '../../models/metadata/org_unit.dart';
import 'base.dart';
import 'download_mixins/base_meta_download_mixin.dart';
import 'download_mixins/org_unit_download_mixin.dart';

class D2OrgUnitRepository extends BaseMetaRepository<D2OrgUnit>
    with
        BaseMetaDownloadServiceMixin<D2OrgUnit>,
        D2OrgUnitDownloadServiceMixin {
  D2OrgUnitRepository(super.db);

  @override
  int? getIdByUid(String uid) {
    return getByUid(uid)?.id;
  }

  Future<List<D2OrgUnit>> getByLevel(int level) async {
    QueryBuilder<D2OrgUnit> queryBuilder = box.query();
    queryBuilder.link(D2OrgUnit_.level, D2OrgUnitLevel_.level.equals(level));
    return queryBuilder.build().findAsync();
  }

  @override
  D2OrgUnit? getByUid(String uid) {
    Query<D2OrgUnit> query = box.query(D2OrgUnit_.uid.equals(uid)).build();
    return query.findFirst();
  }

  @override
  D2OrgUnit mapper(Map<String, dynamic> json) {
    return D2OrgUnit.fromMap(db, json);
  }
}
