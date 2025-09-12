import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/metadata/download_mixins/base_single_meta_download_mixin.dart';

mixin D2OptionDownloadServiceMixin
    on BaseSingleMetaDownloadServiceMixin<D2Option> {
  @override
  String label = "Option";

  @override
  String resource = "option";

  D2OptionDownloadServiceMixin setupDownload(
    D2ClientService client,
    {Map<String, String>? queryParams}
  ) {
    setClient(client);
    setFields(["*"]);
    if (queryParams != null) {
      params = queryParams;
    }

    return this;
  }
}
