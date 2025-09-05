import 'package:dhis2_flutter_toolkit/src/services/sync/on_saving_synchronizations/base_foreground_task.dart';
import 'package:dhis2_flutter_toolkit/src/services/sync/on_saving_synchronizations/data_upload_service.dart';
import 'package:dhis2_flutter_toolkit/src/services/sync/on_saving_synchronizations/notifiable_task.dart';

class DataUploadTaskManager extends BaseForegroundTask
    with NotifiableTask, DataUploadService {
  DataUploadTaskManager({super.background});

  @override
  String taskName = 'Data Upload';
  @override
  String taskId = 'dataUpload';
}
