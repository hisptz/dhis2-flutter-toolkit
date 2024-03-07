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


class D2TrackerDataUploadService {
  D2ObjectBox db;
  D2ClientService client;
  StreamController<D2SyncStatus> uploadController =
      StreamController<D2SyncStatus>();

  D2TrackerDataUploadService(this.db, this.client);

  get uploadStream {
    return uploadController.stream;
  }

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

  Future<void> upload() async {
    await setupDataUpload();
    uploadController.add(D2SyncStatus(status: Status.complete, label: "All"));
    uploadController.close();
  }
}
