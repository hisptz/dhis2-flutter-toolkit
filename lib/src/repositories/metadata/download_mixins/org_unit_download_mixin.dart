import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';

import '../../../models/metadata/organisationUnit.dart';
import 'base_meta_download_mixin.dart';

mixin D2OrgUnitDownloadServiceMixin on BaseMetaDownloadServiceMixin<D2OrgUnit> {
  @override
  String label = "Organisation Units";

  @override
  String resource = "organisationUnits";

  @override
  get extraParams {
    return {"withinUserHierarchy": "true"};
  }

  D2OrgUnitDownloadServiceMixin setupDownload(D2ClientService client) {
    setClient(client);
    setFields(["*"]);
    return this;
  }
}
