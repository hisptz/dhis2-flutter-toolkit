import '../../../models/data/entry.dart';
import '../../../services/entry.dart';
import 'base_tracker_data_download_service_mixin.dart';

mixin TrackedEntityDataDownloadServiceMixin
    on BaseTrackerDataDownloadServiceMixin<D2TrackedEntity> {
  @override
  String label = "Tracked Entities";

  @override
  String downloadResource = "tracker/trackedEntities";

  TrackedEntityDataDownloadServiceMixin setupDownload(D2ClientService client) {
    setClient(client);
    setFields(["*"]);
    return this;
  }

  @override
  Future<void> download() async {
    if (program!.programType != "WITH_REGISTRATION") {
      return;
    }
    await super.download();
  }
}
