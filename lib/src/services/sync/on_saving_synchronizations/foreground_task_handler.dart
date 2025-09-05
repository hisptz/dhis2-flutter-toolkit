import 'dart:async';

import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/services/sync/on_saving_synchronizations/data_foreground_tasks.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

enum DataServicesSyncType {
  upload,
  download;

  static DataServicesSyncType fromString(String value) {
    switch (value) {
      case "upload":
        return upload;
      case "download":
        return download;
      default:
        throw Exception("Invalid DataServicesSyncType: $value");
    }
  }
}

class OfflineVisitsTaskHandler extends TaskHandler {
  StreamController<D2SyncStatus>? downloadController;
  double syncedMetadata = 0;

  // Called when the task is started.
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {}

  // Called based on the eventAction set in ForegroundTaskOptions.
  @override
  void onRepeatEvent(DateTime timestamp) {}

  // Called when the task is destroyed.
  @override
  Future<void> onDestroy(DateTime timestamp) async {
    FlutterForegroundTask.sendDataToMain({"onDestroyFromBadge": true});
    FlutterForegroundTask.stopService();
  }

  // Called when data is sent using `FlutterForegroundTask.sendDataToTask`.6
  @override
  void onReceiveData(Object data) async {
    if (data is Map<String, dynamic>) {
      DataServicesSyncType syncType =
          DataServicesSyncType.fromString(data["syncType"]);
      if (syncType case DataServicesSyncType.upload) {
        DataUploadTaskManager taskManager = DataUploadTaskManager();
        await taskManager.init();
        await taskManager.upload();
        await FlutterForegroundTask.stopService();
      }
    }
  }

}

@pragma(
    'vm:entry-point') // This decorator means that this function calls native code
void offlineVisitsServicesCallback() {
  FlutterForegroundTask.setTaskHandler(OfflineVisitsTaskHandler());
}
