import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/metadata/download_mixins/base_single_meta_download_mixin.dart';

mixin D2OptionSetDownloadServiceMixin
    on BaseSingleMetaDownloadServiceMixin<D2OptionSet> {
  @override
  String label = "Option Set";

  @override
  String resource = "optionSets";

  D2OptionSetDownloadServiceMixin setupDownload(
      D2ClientService client, String optionSetUid) {
    setClient(client);
    setFields(["*"]);
    filters = ["id:eq:$optionSetUid"];

    return this;
  }
}
