import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';

import '../../../models/metadata/user.dart';
import 'base_single_meta_download_mixin.dart';

mixin D2UserDownloadServiceMixin on BaseSingleMetaDownloadServiceMixin<D2User> {
  @override
  String label = "User";

  @override
  String resource = "me";

  D2UserDownloadServiceMixin setupDownload(D2ClientService client) {
    setClient(client);
    setFields(["*", "userRoles[*],userGroups[*],organisationUnits[id]"]);
    return this;
  }
}
