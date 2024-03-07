import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';

import '../../../models/metadata/organisationUnitGroup.dart';
import 'base_meta_download_mixin.dart';

mixin D2OrgUnitGroupDownloadServiceMixin
    on BaseMetaDownloadServiceMixin<D2OrgUnitGroup> {
  @override
  String label = "Organisation Unit Groups";

  @override
  String resource = "organisationUnitGroups";

  @override
  Map<String, dynamic>? extraParams = {"withinUserHierarchy": "true"};

  D2OrgUnitGroupDownloadServiceMixin setupDownload(D2ClientService client) {
    setClient(client);
    setFields(["*"]);
    return this;
  }
}
