import 'dart:async';

import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';

/// This is a service class for downloading and syncing metadata in a DHIS2 system.
class D2MetadataDownloadService {
  D2ObjectBox db;
  D2ClientService client;
  StreamController<D2SyncStatus> controller = StreamController<D2SyncStatus>();

  /// Returns the stream of sync status updates.
  get stream {
    return controller.stream;
  }

  /// Constructs a [D2MetadataDownloadService] with the provided database and client service.
  D2MetadataDownloadService(this.db, this.client);

  /// Sets up the metadata download for the specified [user] and streams the download status.
  ///
  /// Parameters:
  /// - [user]: The [D2User] whose metadata will be downloaded.
  Future setupUserMetadataDownload(D2User user) async {
    D2ProgramRepository programRepository = D2ProgramRepository(db);
    List<String> programs = user.programs;
    programRepository.setupDownload(client, programs).download();
    await controller.addStream(programRepository.downloadStream);
    List<String> dataSets = user.dataSets;
    D2DataSetRepository dataSetRepository = D2DataSetRepository(db);
    dataSetRepository.setupDownload(client, dataSetIds: dataSets).download();
    await controller.addStream(dataSetRepository.downloadStream);
  }

  /// Sets up the metadata download for the system and streams the download status.
  Future setupMetadataDownload() async {
    D2UserRepository userRepository = D2UserRepository(db);
    userRepository.setupDownload(client).download();
    await controller.addStream(userRepository.downloadStream);
    D2SystemInfoRepository sysInfoRepository = D2SystemInfoRepository(db);
    sysInfoRepository.setupDownload(client).download();
    await controller.addStream(sysInfoRepository.downloadStream);
    D2OrgUnitLevelRepository orgUnitLevelRepository =
        D2OrgUnitLevelRepository(db);
    orgUnitLevelRepository.setupDownload(client).download();
    await controller.addStream(orgUnitLevelRepository.downloadStream);
    D2OrgUnitRepository orgUnitRepository = D2OrgUnitRepository(db);
    orgUnitRepository.setupDownload(client).download();
    await controller.addStream(orgUnitRepository.downloadStream);

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

  /// Sets up the metadata sync process and marks it as complete.
  Future setupSync() async {
    await setupMetadataDownload();
    controller
        .add(D2SyncStatus(status: D2SyncStatusEnum.complete, label: "All"));
    controller.close();
  }

  /// Initiates the metadata download and sync process.
  Future<void> download() async {
    await setupSync();
  }
}
