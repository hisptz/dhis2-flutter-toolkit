
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';

import '../../../models/data/tracked_entity.dart';
import '../../../models/data/tracked_entity_attribute_value.dart';
import '../tracked_entity_attribute_value.dart';
import 'base_tracker_data_download_service_mixin.dart';

mixin TrackedEntityDataDownloadServiceMixin
    on BaseTrackerDataDownloadServiceMixin<D2TrackedEntity> {
  @override
  String label = "Tracked Entities";

  @override
  String downloadResource = "tracker/trackedEntities";

  @override
  Future downloadPage(int page) async {
    Map<String, dynamic>? data = await getData<Map<String, dynamic>>(page);
    if (data == null) {
      throw "Error getting data for page $page";
    }

    List<Map<String, dynamic>> entityData =
        data[dataKey ?? downloadResource].cast<Map<String, dynamic>>();

    List<D2TrackedEntity> entities = entityData.map(mapper).toList();

    await box.putManyAsync(entities);

    List<D2TrackedEntityAttributeValue> attributeValues = [];
    for (var element in entityData) {
      List<D2TrackedEntityAttributeValue> attributeValue = element["attributes"]
          ?.map<D2TrackedEntityAttributeValue>((attributeValue) =>
              D2TrackedEntityAttributeValue.fromMap(
                  db, attributeValue, element["trackedEntity"]))
          .toList();
      attributeValues.addAll(attributeValue);
    }
    await D2TrackedEntityAttributeValueRepository(db)
        .saveEntities(attributeValues);
    await downloadRelationships(entityData);
  }

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
