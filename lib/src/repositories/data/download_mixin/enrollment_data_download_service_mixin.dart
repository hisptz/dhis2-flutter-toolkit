import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';

import 'base_tracker_data_download_service_mixin.dart';

mixin D2EnrollmentDownloadServiceMixin
    on BaseTrackerDataDownloadServiceMixin<D2Enrollment> {
  @override
  String label = "Enrollments";

  @override
  String downloadResource = "tracker/enrollments";

  D2EnrollmentDownloadServiceMixin setupDownload(D2ClientService client) {
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
