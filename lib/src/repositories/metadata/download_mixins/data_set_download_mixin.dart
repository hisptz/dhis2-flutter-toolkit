import '../../../models/metadata/data_set.dart';
import '../../../models/metadata/sharing.dart';
import '../../../services/entry.dart';
import '../../../utils/entry.dart';
import '../category.dart';
import '../category_combo.dart';
import '../category_option.dart';
import '../category_option_combo.dart';
import '../data_element.dart';
import '../data_set.dart';
import '../legend.dart';
import '../legend_set.dart';
import '../option.dart';
import '../option_set.dart';
import '../sharing.dart';
import 'base_meta_download_mixin.dart';

mixin D2DataSetDownloadServiceMixin on BaseMetaDownloadServiceMixin<D2DataSet> {
  List<String>? dataSetIds;

  @override
  String label = "Data Sets";

  @override
  String resource = 'dataSets';

  D2DataSetDownloadServiceMixin setupDownload(D2ClientService client,
      {required List<String> dataSetIds}) {
    setClient(client);
    this.dataSetIds = dataSetIds;
    return this;
  }

  List<String> sortOrder = [
    "optionSets",
    "options",
    "legendSets",
    "categoryOptions",
    "categories",
    "categoryCombos",
    "categoryOptionCombos",
    "dataElements",
    "dataSets"
  ];

  syncMeta(String key, List<Map<String, dynamic>> value) {
    switch (key) {
      case "dataElements":
        return D2DataElementRepository(db).saveOffline(value);
      case "options":
        return D2OptionRepository(db).saveOffline(value);
      case "optionSets":
        return D2OptionSetRepository(db).saveOffline(value);
      case "legends":
        return D2LegendRepository(db).saveOffline(value);
      case "legendSets":
        return D2LegendSetRepository(db).saveOffline(value);
      case "categories":
        return D2CategoryRepository(db).saveOffline(value);
      case "categoryCombos":
        return D2CategoryComboRepository(db).saveOffline(value);
      case "categoryOptionCombos":
        return D2CategoryOptionComboRepository(db).saveOffline(value);
      case "categoryOptions":
        return D2CategoryOptionRepository(db).saveOffline(value);
      case "dataSets":
        return D2DataSetRepository(db).saveOffline(value);
    }
  }

  Future<List<D2Sharing>> saveSharingSettings(
    List<Map<String, dynamic>> objects,
  ) {
    return D2SharingRepository(db).saveOffline(objects);
  }

  Future<void> syncDataSet(String dataSetId) async {
    Map<String, dynamic>? dataSetMetadata =
        await client!.httpGet("$resource/$dataSetId/metadata");

    if (dataSetMetadata == null) {
      throw "Error getting data set $dataSetId";
    }

    List<MapEntry<String, dynamic>> metadataEntries = dataSetMetadata.entries
        .where((element) => sortOrder.contains(element.key))
        .toList();
    metadataEntries.sort(
        (a, b) => sortOrder.indexOf(a.key).compareTo(sortOrder.indexOf(b.key)));

    await Future.forEach(metadataEntries,
        (MapEntry<String, dynamic> element) async {
      if (element.key == "system") {
        return;
      }

      List<Map<String, dynamic>> value =
          element.value.cast<Map<String, dynamic>>();
      await syncMeta(element.key, value);

      if (["dataSets"].contains(element.key)) {
        await saveSharingSettings(value);
      }
    });
  }

  @override
  Future initializeDownload() async {
    try {
      if (dataSetIds == null) {
        throw "You need to call setup download with a list of data sets to download";
      }
      D2SyncStatus status = D2SyncStatus(
          synced: 0,
          total: dataSetIds!.length,
          status: D2SyncStatusEnum.syncing,
          label: label);
      downloadController.add(status);
      for (final dataSetId in dataSetIds!) {
        await syncDataSet(dataSetId);
        downloadController.add(status.increment());
      }
      downloadController.add(status.complete());
      downloadController.close();
    } catch (e) {
      downloadController.addError(e);
      rethrow;
    }
  }
}
