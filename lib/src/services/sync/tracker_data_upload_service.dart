import 'dart:async';

import '../../../objectbox.dart';
import '../../models/metadata/program.dart';
import '../../models/metadata/user.dart';
import '../../repositories/data/enrollment.dart';
import '../../repositories/data/event.dart';
import '../../repositories/data/tracked_entity.dart';
import '../../repositories/metadata/program.dart';
import '../../repositories/metadata/user.dart';
import '../../utils/sync_status.dart';
import '../client/client.dart';

/// This is a service class for managing tracker data uploads.
///
/// This class provides methods for setting up and executing tracker data uploads
/// from the local database to the server.
class D2TrackerDataUploadService {
  /// The database instance.
  D2ObjectBox db;

  /// The client service for making network requests.
  D2ClientService client;

  /// The stream controller for managing upload status updates.
  StreamController<D2SyncStatus> uploadController =
      StreamController<D2SyncStatus>();

  /// Constructs a new [D2TrackerDataUploadService].
  ///
  /// - [db] The database instance.
  /// - [client] The client service for making network requests.
  D2TrackerDataUploadService(this.db, this.client);

  /// Gets the upload status stream.
  get uploadStream {
    return uploadController.stream;
  }

  /// Sets up and starts the data upload process.
  ///
  /// This method retrieves the user's programs and initiates the upload
  /// for each program's tracked entities, enrollments, and events.
  Future setupDataUpload() async {
    D2User? user = D2UserRepository(db).get();
    if (user == null) {
      uploadController.addError("Could not get user");
      return;
    }
    List<String> programs = user.programs;

    for (final programId in programs) {
      D2Program? program = D2ProgramRepository(db).getByUid(programId);
      if (program == null) {
        continue;
      }
      if (program.programType == "WITH_REGISTRATION") {
        D2TrackedEntityRepository trackedEntityRepository =
            D2TrackedEntityRepository(db);
        D2EnrollmentRepository enrollmentRepository =
            D2EnrollmentRepository(db);
        trackedEntityRepository.setProgram(program);
        enrollmentRepository.setProgram(program);
        trackedEntityRepository.setupUpload(client).upload();
        await uploadController.addStream(trackedEntityRepository.uploadStream);
        enrollmentRepository.setupUpload(client).upload();
        await uploadController.addStream(enrollmentRepository.uploadStream);
      }
      D2EventRepository eventRepository = D2EventRepository(db);
      eventRepository.setProgram(program);
      eventRepository.setupUpload(client).upload();
      await uploadController.addStream(eventRepository.uploadStream);
    }
  }

  /// Initiates the upload process and marks it as complete upon success.
  Future<void> upload() async {
    await setupDataUpload();
    uploadController
        .add(D2SyncStatus(status: D2SyncStatusEnum.complete, label: "All"));
    uploadController.close();
  }
}
