import 'dart:async';

import 'package:collection/collection.dart';

import '../../../models/data/base.dart';
import '../../../models/data/relationship.dart';
import '../../../services/client/client.dart';
import '../../../utils/pagination.dart';
import '../../../utils/sync_status.dart';
import '../base.dart';
import '../relationship.dart';

mixin BaseTrackerDataDownloadServiceMixin<T extends D2DataResource>
    on D2BaseDataRepository<T> {
  D2ClientService? client;
  StreamController<D2SyncStatus> downloadController =
      StreamController<D2SyncStatus>();
  abstract String downloadResource;
  int downloadPageSize = 100;
  List<String> fields = [];
  List<String> filters = [];
  Map<String, dynamic>? extraParams;
  abstract String label;
  String? dataKey =
      "instances"; //Accessor to the JSON payload from the server. If absent, the resource will be used

  get downloadURL {
    return downloadResource;
  }

  get downloadQueryParams {
    Map<String, String> params = {
      ...(extraParams ?? {}),
      "page": "1",
      "pageSize": "$downloadPageSize",
      "totalPages": "true",
      "program": program!.uid,
      "ouMode": "ACCESSIBLE",
    };
    if (fields.isNotEmpty) {
      params["fields"] = fields.join(",");
    }
    if (filters.isNotEmpty) {
      params["filters"] = filters.join(",");
    }
    return params;
  }

  get downloadStream {
    return downloadController.stream;
  }

  //Currently just checks if there is any data on the specific data model
  bool isSynced() {
    T? entity = box.query().build().findFirst();
    return entity != null;
  }

  setDownloadPageSize(int pageSize) {
    this.downloadPageSize = pageSize;
    return this;
  }

  setClient(D2ClientService client) {
    this.client = client;
    return this;
  }

  setFilters(List<String> filters) {
    this.filters = filters;
    return this;
  }

  setFields(List<String> fields) {
    this.fields = fields;
    return this;
  }

  Future<D2Pagination> getPagination() async {
    Map<String, dynamic>? response = await client!
        .httpGetPagination<Map<String, dynamic>>(downloadURL,
            queryParameters: downloadQueryParams);
    if (response == null) {
      throw "Error getting pagination for data sync";
    }

    final pagination = D2Pagination(
        total: response["total"],
        pageSize: response["pageSize"],
        pageCount: response["pageCount"] ?? 1);

    return pagination;
  }

  Future<D?> getData<D>(int page) async {
    Map<String, String> updatedParams = {
      ...downloadQueryParams,
      "page": page.toString()
    };
    return await client!
        .httpGet<D>(downloadURL, queryParameters: updatedParams);
  }

  Future downloadRelationships(List<Map<String, dynamic>> entityData) async {
    List<D2Relationship> relationships = [];
    for (final entity in entityData) {
      List<D2Relationship> relations = entity["relationships"]
          .map<D2Relationship>((rel) => D2Relationship.fromMap(db, rel))
          .toList()
          .where((rel) =>
              relationships
                  .firstWhereOrNull((element) => element.uid == rel.uid) ==
              null)
          .toList();
      relationships.addAll(relations);
    }

    await D2RelationshipRepository(db).saveEntities(relationships);
  }

  Future downloadPage(int page) async {
    Map<String, dynamic>? data = await getData<Map<String, dynamic>>(page);
    if (data == null) {
      throw "Error getting data for page $page";
    }

    List<Map<String, dynamic>> entityData =
        data[dataKey ?? downloadResource].cast<Map<String, dynamic>>();

    final entities = entityData.map<T>(mapper).toList();
    await box.putManyAsync(entities);
    await downloadRelationships(entityData);
  }

  Future initializeDownload() async {
    try {
      D2SyncStatus status = D2SyncStatus(
          status: D2SyncStatusEnum.initialized,
          label: "$label for ${program!.name} program");
      downloadController.add(status);
      D2Pagination pagination = await getPagination();
      status.setTotal(pagination.pageCount);
      downloadController.add(status);
      status.updateStatus(D2SyncStatusEnum.syncing);
      for (int page = 1; page <= pagination.pageCount; page++) {
        await downloadPage(page);
        downloadController.add(status.increment());
      }
      downloadController.add(status.complete());
      await downloadController.close();
    } catch (e) {
      downloadController.addError(e);
      rethrow;
    }
  }

  /*
  * So apparently there is some metadata that comes with pagination and stuff. So we have to make sure we accommodate for that.
  * To enable this service to provide status of the operation, we are going to use a stream. The sync method will return a stream with progress data.
  *
  * How it works:
  *
  * 1. Get data pagination.
  * 2. Send the first sync status with status initialized and total count
  * 3. For each page, get the data, map into dart objects of type T and save to the box. Then update status by incrementing synced
  * 4. When done send a complete sync status
  * 5. Close the stream
  *

  ** */

  Future<void> download() async {
    await initializeDownload();
  }
}
