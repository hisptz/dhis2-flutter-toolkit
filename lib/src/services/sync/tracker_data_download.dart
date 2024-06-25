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

/// This is a service class for managing tracker data downloads.
///
/// This class provides methods for setting up and executing tracker data downloads
/// from the server to the local database.
class D2TrackerDataDownloadService {
  /// The database instance.
  D2ObjectBox db;

  /// The client service for making network requests.
  D2ClientService client;

  /// The stream controller for managing download status updates.
  StreamController<D2SyncStatus> downloadController =
      StreamController<D2SyncStatus>();

  /// Constructs a new [D2TrackerDataDownloadService].
  ///
  /// - [db] The database instance.
  /// - [client] The client service for making network requests.
  D2TrackerDataDownloadService(this.db, this.client);

  /// Gets the download status stream.
  get downloadStream {
    return downloadController.stream;
  }

  /// Sets up and starts the data download process.
  ///
  /// This method retrieves the user's programs and initiates the download
  /// for each program's tracked entities, enrollments, and events.
  Future setupDataDownload() async {
    D2User? user = D2UserRepository(db).get();
    if (user == null) {
      downloadController.addError("Could not get user");
      downloadController.close();
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
        trackedEntityRepository.setProgram(program);
        D2EnrollmentRepository enrollmentRepository =
            D2EnrollmentRepository(db);
        enrollmentRepository.setProgram(program);
        trackedEntityRepository.setupDownload(client).download();
        await downloadController
            .addStream(trackedEntityRepository.downloadStream);
        enrollmentRepository.setupDownload(client).download();
        await downloadController.addStream(enrollmentRepository.downloadStream);
      }

      D2EventRepository eventRepository = D2EventRepository(db);
      eventRepository.setProgram(program);
      eventRepository.setupDownload(client).download();
      await downloadController.addStream(eventRepository.downloadStream);
    }
  }

  /// Initiates the download process and marks it as complete upon success.
  Future<void> download() async {
    await setupDataDownload();
    downloadController
        .add(D2SyncStatus(status: D2SyncStatusEnum.complete, label: "All"));
    downloadController.close();
  }
}
