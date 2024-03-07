import '../../../objectbox.g.dart';

import '../../models/metadata/org_unit_level.dart';
import 'base.dart';
import 'download_mixins/base_meta_download_mixin.dart';
import 'download_mixins/org_unit_level_download_mixin.dart';



class D2OrgUnitLevelRepository
    extends BaseMetaRepository<D2OrgUnitLevel>
    with
        BaseMetaDownloadServiceMixin<D2OrgUnitLevel>,
        D2OrgUnitLevelDownloadServiceMixin {
  D2OrgUnitLevelRepository(super.db);

  @override
  D2OrgUnitLevel? getByUid(String uid) {
    Query<D2OrgUnitLevel> query =
        box.query(D2OrganisationUnitLevel_.uid.equals(uid)).build();
    return query.findFirst();
  }

  @override
  D2OrgUnitLevel mapper(Map<String, dynamic> json) {
    return D2OrgUnitLevel.fromMap(db, json);
  }
}
