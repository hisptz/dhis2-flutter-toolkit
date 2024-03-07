
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';

import '../../../models/metadata/org_unit_level.dart';
import 'base_meta_download_mixin.dart';

mixin D2OrgUnitLevelDownloadServiceMixin
    on BaseMetaDownloadServiceMixin<D2OrgUnitLevel> {
  @override
  String label = "Organisation Unit Levels";

  @override
  String resource = "organisationUnitLevels";

  @override
  Map<String, dynamic>? extraParams = {"withinUserHierarchy": "true"};

  D2OrgUnitLevelDownloadServiceMixin setupDownload(D2ClientService client) {
    setClient(client);
    setFields(["*"]);
    return this;
  }
}
