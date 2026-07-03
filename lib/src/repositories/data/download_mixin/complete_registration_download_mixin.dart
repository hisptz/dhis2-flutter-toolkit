import 'dart:async';

import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';

import '../base_aggregate.dart';

mixin CompleteRegistrationDownloadMixin
    on D2BaseAggregateRepository<D2CompleteDataSetRegistration> {
  D2ClientService? _dlClient;
  StreamController<D2SyncStatus> downloadController =
      StreamController<D2SyncStatus>();
  String downloadResource = "completeDataSetRegistrations";
  final String _dlLabel = 'Complete registrations';
  String dataKey = "completeDataSetRegistrations";

  List<String> _orgUnitIds = [];
  List<String> _periods = [];
  List<String> _dataSetIds = [];

  Stream<D2SyncStatus> get downloadStream => downloadController.stream;

  CompleteRegistrationDownloadMixin setupDownload({
    required D2ClientService client,
    required List<String> dataSetIds,
    required List<String> periods,
    required List<String> orgUnitIds,
  }) {
    _dlClient = client;
    _dataSetIds = dataSetIds;
    _periods = periods;
    _orgUnitIds = orgUnitIds;
    return this;
  }

  Future<void> _downloadForDataSet(String dataSetId) async {
    Map<String, String> params = {
      'dataSet': dataSetId,
      'orgUnit': _orgUnitIds.join(','),
      'period': _periods.join(','),
    };

    Map<String, dynamic>? response = await _dlClient!
        .httpGet<Map<String, dynamic>>(downloadResource,
            queryParameters: params);

    if (response == null) return;

    List? items = response[dataKey];
    if (items == null || items.isEmpty) return;

    List<Map<String, dynamic>> registrations =
        items.cast<Map<String, dynamic>>();
    await saveOffline(registrations);
  }

  Future<void> download() async {
    try {
      D2SyncStatus status =
          D2SyncStatus(status: D2SyncStatusEnum.initialized, label: _dlLabel);
      downloadController.add(status);
      status.setTotal(_dataSetIds.length);
      status.updateStatus(D2SyncStatusEnum.syncing);

      for (String dataSetId in _dataSetIds) {
        await _downloadForDataSet(dataSetId);
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
