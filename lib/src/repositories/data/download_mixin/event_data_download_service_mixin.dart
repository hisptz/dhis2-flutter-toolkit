import '../../../models/data/entry.dart';
import '../../../services/entry.dart';
import 'base_tracker_data_download_service_mixin.dart';

mixin D2EventDataDownloadServiceMixin
    on BaseTrackerDataDownloadServiceMixin<D2Event> {
  @override
  String label = "Events";

  @override
  String downloadResource = "tracker/events";

  D2EventDataDownloadServiceMixin setupDownload(D2ClientService client) {
    setClient(client);
    setFields(["*"]);
    return this;
  }
}
