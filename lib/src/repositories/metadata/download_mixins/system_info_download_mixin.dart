import '../../../models/metadata/system_info.dart';
import '../../../services/entry.dart';
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
