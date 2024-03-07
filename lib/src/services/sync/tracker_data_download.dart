import 'dart:async';
import '../../../objectbox.dart';
import '../../models/metadata/program.dart';
import '../../models/metadata/user.dart';
import '../../repositories/data/enrollment.dart';
import '../../repositories/data/event.dart';
import '../../repositories/data/tracked_entity.dart';
import '../../repositories/metadata/program.dart';
import '../../repositories/metadata/user.dart';
import '../../utils/download_status.dart';
import '../client/client.dart';

class D2TrackerDataDownloadService {
  D2ObjectBox db;
  D2ClientService client;
  StreamController<DownloadStatus> downloadController =
      StreamController<DownloadStatus>();

  D2TrackerDataDownloadService(this.db, this.client);

  get downloadStream {
    return downloadController.stream;
  }


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

  Future<void> download() async {
    await setupDataDownload();
    downloadController
        .add(DownloadStatus(status: Status.complete, label: "All"));
    downloadController.close();
  }
}
