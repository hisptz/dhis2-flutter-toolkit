import '../../../models/metadata/tracked_entity_type.dart';
import '../../../services/client/client.dart';
import 'base_meta_download_mixin.dart';

mixin D2TrackedEntityTypeDownloadServiceMixin
    on BaseMetaDownloadServiceMixin<D2TrackedEntityType> {
  late List<String> programIds;

  @override
  String label = "Tracked Entity Types";

  @override
  String resource = "trackedEntityTypes";

  D2TrackedEntityTypeDownloadServiceMixin setupDownload(
      D2ClientService client) {
    setClient(client);
    setFields(["*"]);
    return this;
  }
}
