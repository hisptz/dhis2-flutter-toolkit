import 'dart:async';
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/services/sync/on_saving_synchronizations/base_foreground_task.dart';
import 'package:dhis2_flutter_toolkit/src/services/sync/on_saving_synchronizations/notifiable_task.dart';
import 'package:fluttertoast/fluttertoast.dart';


mixin DataUploadService on BaseForegroundTask, NotifiableTask {
  Future<void> uploadTrackerData(D2SyncStatus status) async {
    try {
      //Syncing all trackedEntities
      D2TrackedEntityRepository trackedEntityRepo =
          D2TrackedEntityRepository(db!);
      trackedEntityRepo.initializeQuery();
      await trackedEntityRepo.setupUpload(client!).upload();
      activeController!.add(status.increment());
      //Syncing all enrollments
      D2EnrollmentRepository enrollmentRepo = D2EnrollmentRepository(db!);
      enrollmentRepo.initializeQuery();
      await enrollmentRepo.setupUpload(client!).upload();
      activeController!.add(status.increment());
      //Syncing all events
      D2EventRepository eventRepo = D2EventRepository(db!);
      eventRepo.initializeQuery();
      await eventRepo.setupUpload(client!).upload();
      activeController!.add(status.increment());
      //Syncing all relationships
      D2RelationshipRepository relationshipRepo = D2RelationshipRepository(db!);
      await relationshipRepo.setupUpload(client!).upload();
      activeController!.add(status.increment());
    } catch (e, stackTrace) {
      // Log error to D2AppLog
      D2AppLog.log(
        code: 400,
        message: '$e',
        process: 'UPLOAD_ERROR',
        stackTrace: stackTrace.toString(),
      ).save(db!);

      Fluttertoast.showToast(
          msg:
              'There were issues uploading the data. Please try again or contact the system administrator');
    }
  }

  Stream<D2SyncStatus> get stream {
    return activeController!.stream;
  }

  Future<void> upload() async {
    try {
      await D2ImportSummaryErrorRepository(db!).clearErrors();
      activeController = StreamController<D2SyncStatus>(sync: true);
      await setupNotification();
      D2SyncStatus status =
          D2SyncStatus(status: D2SyncStatusEnum.syncing, label: 'Offline data');
      status.setTotal(5); //Number of operations to be done during upload
      activeController!.add(status);
      await uploadTrackerData(status);
      activeController!.add(status.increment());
      activeController!.add(status.complete());
      await activeController!.close();
    } catch (e, stackTrace) {
      D2AppLog errorLog = D2AppLog.log(
        code: 400,
        message: '$e',
        process: 'data-upload',
        stackTrace: stackTrace.toString(),
      );
      D2AppLogRepository(db!).box.put(errorLog);
      activeController!.close();
      Fluttertoast.showToast(
          msg:
              'There were issues uploading the data. Please try again or contact the system administrator');
    }
  }
}
