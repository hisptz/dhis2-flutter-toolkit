import 'dart:async';

import 'package:objectbox/objectbox.dart';

import '../../../../dhis2_flutter_toolkit.dart';
import '../../../models/data/base.dart';
import '../base.dart';

mixin BaseTrackerDataUploadServiceMixin<T extends SyncDataSource>
    on BaseDataRepository<T> {
  D2ClientService? client;
  int uploadPageSize = 100;
  String uploadResource = "tracker";
  abstract String label;
  abstract String uploadDataKey;
  StreamController<D2SyncStatus> uploadController =
      StreamController<D2SyncStatus>();

  setUnSyncedQuery();

  get uploadQueryParams {
    return {
      "async": "false",
      "reportMode": "ERRORS",
      "importMode": "COMMIT",
      "importStrategy": "CREATE_AND_UPDATE",
      "atomicMode": "ALL",
      "validationMode": "FULL",
      "skipSideEffects": "TRUE",
      "skipPatternValidation": "TRUE",
      "skipRuleEngine": "TRUE"
    };
  }

  get uploadURL {
    return uploadResource;
  }

  get uploadStream {
    return uploadController.stream;
  }

  int getUnSyncedCount() {
    return query.count();
  }

  Future<Map<String, dynamic>> uploadPage(int page) async {
    Query<T> localQuery = query;
    localQuery
      ..offset = (page * uploadPageSize)
      ..limit = uploadPageSize;
    List<T> entities = await localQuery.findAsync();
    List<Map<String, dynamic>> entityPayload =
        await Future.wait(entities.map((entity) => entity.toMap(db: db)));

    Map<String, dynamic> payload = {uploadDataKey: entityPayload};
    Map<String, dynamic> response = await client!
        .httpPost<Map<String, dynamic>>(uploadURL, payload,
            queryParameters: uploadQueryParams);

    //TODO: Handle import summary. Don't update sync status of failed payloads

    for (T entity in entities) {
      entity.synced = true;
    }
    await box.putManyAsync(entities);
    return response;
  }

  BaseTrackerDataUploadServiceMixin<T> setUploadPageSize(int pageSize) {
    this.uploadPageSize = pageSize;
    return this;
  }

  BaseTrackerDataUploadServiceMixin setClient(D2ClientService client) {
    this.client = client;
    return this;
  }

  BaseTrackerDataUploadServiceMixin setupUpload(D2ClientService client) {
    setClient(client);
    return this;
  }

  Future upload() async {
    if (client == null) {
      throw "Error starting upload. Make sure you call setClient first";
    }
    try {
      setUnSyncedQuery();
      //TODO: Handle import summary
      int count = getUnSyncedCount();
      int pages = (count / uploadPageSize).ceil().clamp(1, 10);
      D2SyncStatus status = D2SyncStatus(
          synced: 0,
          total: pages,
          status: D2SyncStatusEnum.initialized,
          label: "$label for ${program!.name} program");
      uploadController.add(status);

      status.updateStatus(D2SyncStatusEnum.syncing);
      for (int page = 0; page < pages; page++) {
        await uploadPage(page); //TODO: Handle import summary
        status.increment();
        uploadController.add(status);
      }
      status.complete();
      uploadController.add(status);
      await uploadController.close();
    } catch (e) {
      uploadController.addError(e);
      rethrow;
    }
  }

  Future uploadOne(T entity) async {
    Map<String, dynamic> entityPayload = await entity.toMap(db: db);
    Map<String, dynamic> payload = {
      uploadDataKey: [entityPayload]
    };
    Map response = await client!
        .httpPost(uploadURL, payload, queryParameters: uploadQueryParams);
    entity.synced = true;
    box.put(entity);
    return response;
  }
}
