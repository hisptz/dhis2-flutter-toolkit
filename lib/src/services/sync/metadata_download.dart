import 'dart:async';

import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';

import '../../../objectbox.dart';
import '../../utils/download_status.dart';

class D2MetadataDownloadService {
  ObjectBox db;
  D2ClientService client;
  StreamController<DownloadStatus> controller =
      StreamController<DownloadStatus>();

  get stream {
    return controller.stream;
  }

  D2MetadataDownloadService(this.db, this.client);

  Future setupUserMetadataDownload(D2User user) async {
    D2ProgramRepository programRepository = D2ProgramRepository(db);
    List<String> programs = user.programs;
    programRepository.setupDownload(client, programs).download();
    await controller.addStream(programRepository.downloadStream);
  }

  Future setupMetadataDownload() async {
    D2UserRepository userRepository = D2UserRepository(db);
    userRepository.setupDownload(client).download();
    await controller.addStream(userRepository.downloadStream);
    D2SystemInfoRepository sysInfoRepository = D2SystemInfoRepository(db);
    sysInfoRepository.setupDownload(client).download();
    await controller.addStream(sysInfoRepository.downloadStream);
    D2OrgUnitRepository orgUnitRepository = D2OrgUnitRepository(db);
    orgUnitRepository.setupDownload(client).download();
    await controller.addStream(orgUnitRepository.downloadStream);

    D2OrgUnitLevelRepository orgUnitLevelRepository =
        D2OrgUnitLevelRepository(db);
    orgUnitLevelRepository.setupDownload(client).download();
    await controller.addStream(orgUnitLevelRepository.downloadStream);

    D2OrgUnitGroupRepository orgUnitGroupRepository =
        D2OrgUnitGroupRepository(db);
    orgUnitGroupRepository.setupDownload(client).download();
    await controller.addStream(orgUnitGroupRepository.downloadStream);

    D2TrackedEntityTypeRepository teiTypeRepository =
        D2TrackedEntityTypeRepository(db);
    teiTypeRepository.setupDownload(client).download();
    await controller.addStream(teiTypeRepository.downloadStream);

    D2RelationshipTypeRepository relationshipTypeRepository =
        D2RelationshipTypeRepository(db);
    relationshipTypeRepository.setupDownload(client).download();
    await controller.addStream(relationshipTypeRepository.downloadStream);

    D2User? user = userRepository.get();
    if (user == null) {
      controller.addError("Could not get user");
      return;
    }
    await setupUserMetadataDownload(user);
  }

  Future setupSync() async {
    await setupMetadataDownload();
    controller.add(DownloadStatus(status: Status.complete, label: "All"));
    controller.close();
  }

  Future<void> download() async {
    await setupSync();
  }
}
