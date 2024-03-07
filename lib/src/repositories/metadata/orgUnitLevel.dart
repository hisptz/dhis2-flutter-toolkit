import '../../../objectbox.g.dart';

import '../../models/metadata/organisationUnitLevel.dart';
import 'base.dart';
import 'download_mixins/base_meta_download_mixin.dart';
import 'download_mixins/org_unit_level_download_mixin.dart';



class D2OrgUnitLevelRepository
    extends BaseMetaRepository<D2OrganisationUnitLevel>
    with
        BaseMetaDownloadServiceMixin<D2OrganisationUnitLevel>,
        D2OrgUnitLevelDownloadServiceMixin {
  D2OrgUnitLevelRepository(super.db);

  @override
  D2OrganisationUnitLevel? getByUid(String uid) {
    Query<D2OrganisationUnitLevel> query =
        box.query(D2OrganisationUnitLevel_.uid.equals(uid)).build();
    return query.findFirst();
  }

  @override
  D2OrganisationUnitLevel mapper(Map<String, dynamic> json) {
    return D2OrganisationUnitLevel.fromMap(db, json);
  }
}
