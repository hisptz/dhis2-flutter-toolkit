import 'package:dhis2_flutter_toolkit/src/services/sync/on_saving_synchronizations/foreground_task_handler.dart' show offlineVisitsServicesCallback;
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:http/http.dart' as http;


class InternetUtils {
  static Future<bool> hasInternetAccess() async {
    try {
      final response = await http
          .get(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
  static Future<void> triggerUploading({int serviceId = 0}) async {
  await FlutterForegroundTask.startService(
      serviceId: serviceId,
      notificationTitle: 'Preparing for data upload...',
      notificationText: 'Tap to return to the app',
      notificationInitialRoute: '/modules/sync/data',
      callback: offlineVisitsServicesCallback, 
    );

    FlutterForegroundTask.sendDataToTask({
      "syncType": "upload",
    });
  }
}