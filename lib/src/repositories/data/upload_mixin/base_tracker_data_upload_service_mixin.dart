import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/models/data/base_deletable.dart';
import 'package:flutter/cupertino.dart';
import 'package:objectbox/objectbox.dart';

import '../../../models/data/base.dart';

mixin BaseTrackerDataUploadServiceMixin<T extends SyncDataSource>
    on D2BaseTrackerDataRepository<T>, D2BaseTrackerDataQueryMixin<T> {
  D2ClientService? client;
  int uploadPageSize = 10;
  String uploadResource = "tracker";
  abstract String label;
  abstract String uploadDataKey;
  StreamController<D2SyncStatus> uploadController =
      StreamController<D2SyncStatus>();

  Query<T> getUnSyncedQuery();

  Query<T> getDeletedQuery();

  Map<String, String> get uploadQueryParams {
    return {
      "async": "false",
      "reportMode": "ERRORS",
      "importMode": "COMMIT",
      "importStrategy": "CREATE_AND_UPDATE",
      "atomicMode": "OBJECT",
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

  List<D2ImportSummaryError> getItemsWithErrorsEntityUidFromImportSummary(
      Map<String, dynamic> importSummary) {
    List errorReports = importSummary["validationReport"]["errorReports"];
    return errorReports
        .map<D2ImportSummaryError>(
            (errorReport) => D2ImportSummaryError.fromMap(db, errorReport))
        .toList();
  }

  Future<void> deleteSoftDeletedEntitiesByPage(int page) async {
    Query<T> query = getDeletedQuery();

    query
      ..limit = uploadPageSize
      ..offset = uploadPageSize * page;

    List<T> entities = await query.findAsync();
    List<Map<String, dynamic>> entityPayload =
        await Future.wait(entities.map((entity) => entity.toMap(db: db)));
    Map<String, dynamic> payload = {uploadDataKey: entityPayload};

    Map<String, String> params = uploadQueryParams;

    params.addAll({"importStrategy": "DELETE", "atomicMode": "OBJECT"});
    try {
      Map<String, dynamic> response = await client!
          .httpPost<Map<String, dynamic>>(uploadURL, payload,
              queryParameters: params);
      debugPrint(response.toString());
      //We won't deal with this response as it will contain errors. This is because the entities may not exist in the server
      //We then delete them locally
      for (T entity in entities) {
        if (entity is D2BaseDeletable) {
          (entity as D2BaseDeletable).delete(db);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {}
  }

  Future<void> deleteSoftDeletedEntities() async {
    Query<T> query = getDeletedQuery();
    int count = query.count();
    int pages = (count / uploadPageSize).ceil();

    for (int page = 0; page < pages; page++) {
      await deleteSoftDeletedEntitiesByPage(page);
    }
  }

  Future<Map<String, dynamic>> uploadPage(int page,
      {required Query<T> query}) async {
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

    List errorReports = response["validationReport"]["errorReports"];

    if (errorReports.isNotEmpty) {
      List<D2ImportSummaryError> importSummary =
          getItemsWithErrorsEntityUidFromImportSummary(response);
      List<String> entitiesIdsWithErrors =
          importSummary.map<String>((summary) => summary.uid).toList();

      List<String> errorMessages = errorReports
          .map<String>((errorReport) => errorReport["message"] as String)
          .toList();

      List<T> entitiesWithoutErrors = entities
          .whereNot((T entity) => entitiesIdsWithErrors.contains(entity.uid))
          .toList();

      if (entitiesIdsWithErrors.isNotEmpty) {
        throw 'Error: $errorMessages';
      }

      for (T entity in entitiesWithoutErrors) {
        entity.synced = true;
      }
      await box.putManyAsync(entitiesWithoutErrors);
      if (importSummary.isNotEmpty) {
        await D2ImportSummaryErrorRepository(db).saveEntities(importSummary);
      }
    } else {
      for (T entity in entities) {
        entity.synced = true;
      }
      await box.putManyAsync(entities);
    }
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
      await deleteSoftDeletedEntities();
      await D2ImportSummaryErrorRepository(db).clearErrors();
      Query<T> query = getUnSyncedQuery();
      int count = query.count();
      if (count == 0) {
        if (!uploadController.hasListener) {
          uploadController.stream.listen(null);
        }
        uploadController
            .add(D2SyncStatus(status: D2SyncStatusEnum.complete, label: label));
        await uploadController.close();
        return;
      }
      int pages = (count / uploadPageSize).ceil();
      D2SyncStatus status = D2SyncStatus(
          synced: 0,
          total: pages,
          status: D2SyncStatusEnum.initialized,
          label: "$label for ${program!.name} program");
      uploadController.add(status);

      status.updateStatus(D2SyncStatusEnum.syncing);
      for (int page = 0; page < pages; page++) {
        await uploadPage(page, query: query); //TODO: Handle import summary
        status.increment();
        uploadController.add(status);
      }
      status.complete();
      uploadController.add(status);
      if (!uploadController.hasListener) {
        uploadController.stream.listen(null);
      }
      await uploadController.close();
    } catch (e) {
      if (!uploadController.hasListener) {
        uploadController.stream.listen(null);
      }
      uploadController.addError(e);
      uploadController.close();
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

    List errorReports = response["validationReport"]["errorReports"];
    if (errorReports.isNotEmpty) {
      List<D2ImportSummaryError> importSummary =
          getItemsWithErrorsEntityUidFromImportSummary(
              response as Map<String, dynamic>);
      List<String> errorMessages = errorReports
          .map<String>((errorReport) => errorReport["message"] as String)
          .toList();
      entity.synced = false;
      if (importSummary.isNotEmpty) {
        await D2ImportSummaryErrorRepository(db).saveEntities(importSummary);
      }
      throw 'Error: $errorMessages';
    } else {
      entity.synced = true;
      box.put(entity);
    }

    return response;
  }
}
