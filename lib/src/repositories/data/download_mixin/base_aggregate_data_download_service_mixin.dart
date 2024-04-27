import 'dart:async';

import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';

import '../base_aggregate.dart';

mixin BaseAggregateDataDownloadServiceMixin
    on D2BaseAggregateRepository<D2DataValueSet> {
  D2ClientService? client;
  StreamController<D2SyncStatus> downloadController =
      StreamController<D2SyncStatus>();
  String downloadResource = "dataValueSets";
  int downloadPageSize = 100;

  List<String> orgUnitIds = [];
  List<String> periods = [];
  List<String> dataSetIds = [];
  String dataKey = "dataValues";

  get downloadStream {
    return downloadController.stream;
  }

  Future downloadDataSetData(String dataSetId) async {
    Map<String, String> params = {
      'dataSet': dataSetId,
      'orgUnit': orgUnitIds.join(','),
      'period': periods.join(',')
    };
    String url = downloadResource;

    Map<String, dynamic>? response = await client!
        .httpGet<Map<String, dynamic>>(url, queryParameters: params);
    if (response == null) {
      return;
    }
    List<Map<String, dynamic>> dataValueObjects =
        response[dataKey].cast<Map<String, dynamic>>();
    await saveOffline(dataValueObjects);
  }

  BaseAggregateDataDownloadServiceMixin setupDownload(
      {required D2ClientService client,
      required List<String> dataSetIds,
      required List<String> periods,
      required List<String> orgUnitIds}) {
    this.periods = periods;
    this.orgUnitIds = orgUnitIds;
    this.dataSetIds = dataSetIds;
    this.client = client;
    return this;
  }

  Future<void> download() async {
    try {
      D2SyncStatus status = D2SyncStatus(
          status: D2SyncStatusEnum.initialized, label: 'Data value sets');
      downloadController.add(status);
      status.setTotal(dataSetIds.length);
      status.updateStatus(D2SyncStatusEnum.syncing);

      for (String dataSetId in dataSetIds) {
        await downloadDataSetData(dataSetId);
        status.increment();
        downloadController.add(status);
      }

      downloadController.add(status.complete());
      await downloadController.close();
    } catch (e) {
      downloadController.addError(e);
      rethrow;
    }
  }
}
