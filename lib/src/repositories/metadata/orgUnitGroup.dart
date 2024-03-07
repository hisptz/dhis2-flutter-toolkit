import '../../../objectbox.g.dart';

import '../../models/metadata/organisationUnitGroup.dart';
import 'base.dart';
import 'download_mixins/base_meta_download_mixin.dart';
import 'download_mixins/org_unit_group_download_mixin.dart';

class D2OrgUnitGroupRepository extends BaseMetaRepository<D2OrgUnitGroup>
    with
        BaseMetaDownloadServiceMixin<D2OrgUnitGroup>,
        D2OrgUnitGroupDownloadServiceMixin {
  D2OrgUnitGroupRepository(super.db);

  @override
  D2OrgUnitGroup? getByUid(String uid) {
    Query<D2OrgUnitGroup> query =
        box.query(D2OrgUnitGroup_.uid.equals(uid)).build();

    return query.findFirst();
  }

  @override
  D2OrgUnitGroup mapper(Map<String, dynamic> json) {
    return D2OrgUnitGroup.fromMap(db, json);
  }
}
