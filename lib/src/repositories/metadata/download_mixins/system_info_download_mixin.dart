import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';

import '../../../models/metadata/systemInfo.dart';
import 'base_single_meta_download_mixin.dart';

mixin D2SystemInfoDownloadServiceMixin
    on BaseSingleMetaDownloadServiceMixin<D2SystemInfo> {
  @override
  String label = "System information";

  @override
  String resource = "system/info";

  D2SystemInfoDownloadServiceMixin setupDownload(D2ClientService client) {
    setClient(client);
    return this;
  }
}
