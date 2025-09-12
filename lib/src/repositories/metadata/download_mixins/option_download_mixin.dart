import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/metadata/download_mixins/base_single_meta_download_mixin.dart';

mixin D2OptionDownloadServiceMixin
    on BaseSingleMetaDownloadServiceMixin<D2Option> {
  @override
  String label = "Options";

  @override
  String resource = "options";

  @override
  Future<void> download() async {
    D2SyncStatus status = D2SyncStatus(
        synced: 0,
        total: 1,
        status: D2SyncStatusEnum.initialized,
        label: label);
    downloadController.add(status);
    Map<String, dynamic>? data = await getData<Map<String, dynamic>>();
    if (data == null) {
      downloadController.addError("Could not get $label");
      return;
    }
    for (Map<String, dynamic> optionObject in data["options"] ?? []) {
      D2Option entity = mapper(optionObject);
      box.put(entity);
    }
    status.increment();
    downloadController.add(status.complete());
    await downloadController.close();
  }

  D2OptionDownloadServiceMixin setupDownload(D2ClientService client,
      {Map<String, String>? queryParams}) {
    setClient(client);
    setFields(["*"]);
    if (queryParams != null) {
      params = queryParams;
    }

    return this;
  }
}
