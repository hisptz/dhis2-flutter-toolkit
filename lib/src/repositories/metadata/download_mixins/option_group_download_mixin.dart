import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/metadata/download_mixins/base_single_meta_download_mixin.dart';

mixin D2OptionGroupDownloadServiceMixin
    on BaseSingleMetaDownloadServiceMixin<D2OptionGroup> {
  @override
  String label = "Option Groups";

  @override
  String resource = "optionGroups";

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
    for (Map<String, dynamic> optionGroupObject in data["optionGroups"] ?? []) {
      D2OptionGroup entity = mapper(optionGroupObject);
      box.put(entity);
    }
    status.increment();
    downloadController.add(status.complete());
    await downloadController.close();
  }

  D2OptionGroupDownloadServiceMixin setupDownload(D2ClientService client,
      {Map<String, String>? queryParams}) {
    setClient(client);
    setFields(["*"]);
    if (queryParams != null) {
      params = queryParams;
    }

    return this;
  }
}
