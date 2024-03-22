import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';

import 'base_meta_download_mixin.dart';

mixin D2OrgUnitDownloadServiceMixin on BaseMetaDownloadServiceMixin<D2OrgUnit> {
  @override
  String label = "Organisation Units";

  @override
  String resource = "organisationUnits";

  @override
  get extraParams {
    return {"order": "level:asc"};
  }

  @override
  Future downloadPage(int page) async {
    Map<String, dynamic>? data = await getData<Map<String, dynamic>>(page);
    if (data == null) {
      throw "Error getting data for page $page";
    }
    List<Map<String, dynamic>> entityData =
        data[dataKey ?? resource].cast<Map<String, dynamic>>();
    //We need to make sure we save the org units level-wise. This will ensure parent is well connected to the children
    //First get available levels in this batch
    List<int> levels = entityData
        .map<int>((Map<String, dynamic> data) => data["level"] as int)
        .toSet()
        .toList();
    //Then sort it
    levels.sort((a, b) => a.compareTo(b));

    //Then loop through to save the entities for each level separately
    for (int level in levels) {
      List<Map<String, dynamic>> levelEntityData = entityData
          .where((Map<String, dynamic> data) => data["level"] as int == level)
          .toList();
      List<D2OrgUnit> entities = levelEntityData.map(mapper).toList();
      await box.putManyAsync(entities);
    }
  }

  D2OrgUnitDownloadServiceMixin setupDownload(D2ClientService client) {
    setClient(client);
    setFields(["*"]);
    return this;
  }
}
