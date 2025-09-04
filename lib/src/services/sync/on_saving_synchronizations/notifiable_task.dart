import 'package:dhis2_flutter_toolkit/src/services/sync/on_saving_synchronizations/base_foreground_task.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

mixin NotifiableTask on BaseForegroundTask {
  setupNotification() async {
    if (!background) {
      FlutterForegroundTask.updateService(
        notificationTitle: taskName,
        notificationText: 'Setting up task...',
      );
      activeController?.stream.listen((status) {
        FlutterForegroundTask.updateService(
          notificationTitle: taskName,
          notificationText:
              '${status.label} ${(status.progress * 100).toInt()} %',
        );
        FlutterForegroundTask.sendDataToMain({taskId: status.toMap()});
      });
    }
  }
}
