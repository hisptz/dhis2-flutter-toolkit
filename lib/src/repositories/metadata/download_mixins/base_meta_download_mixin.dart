import 'dart:async';

import '../../../models/metadata/base.dart';
import '../../../services/client/client.dart';
import '../../../utils/pagination.dart';
import '../../../utils/sync_status.dart';
import '../base.dart';

mixin BaseMetaDownloadServiceMixin<T extends D2MetaResource>
    on BaseMetaRepository<T> {
  D2ClientService? client;
  StreamController<D2SyncStatus> downloadController = StreamController();
  int pageSize = 100;
  abstract String resource;
  abstract String label;
  List<String> downloadFields = [];
  List<String> downloadFilters = [];
  Map<String, dynamic>? extraParams;
  String?
      dataKey; //Accessor to the JSON payload from the server. If absent, the resource will be used

  get url {
    return resource;
  }

  get queryParams {
    Map<String, String> params = {
      ...(extraParams ?? {}),
      "page": "1",
      "pageSize": "$pageSize",
      "totalPages": "true"
    };
    if (downloadFields.isNotEmpty) {
      params["fields"] = downloadFields.join(",");
    }
    if (downloadFilters.isNotEmpty) {
      params["filters"] = downloadFilters.join(",");
    }
    return params;
  }

  get downloadStream {
    return downloadController.stream;
  }

  setPageSize(int pageSize) {
    this.pageSize = pageSize;
    return this;
  }

  BaseMetaDownloadServiceMixin<T> setClient(D2ClientService client) {
    this.client = client;
    return this;
  }

  BaseMetaDownloadServiceMixin<T> setFilters(List<String> filters) {
    this.downloadFilters.addAll(filters);
    return this;
  }

  BaseMetaDownloadServiceMixin<T> setFields(List<String> fields) {
    this.downloadFields.addAll(fields);
    return this;
  }

  //Currently just checks if there is any data on the specific data model
  bool isSynced() {
    List<T> entity = box.getAll();
    return entity.isNotEmpty;
  }

  Future<Pagination> getPagination() async {
    Map<String, dynamic>? response = await client!
        .httpGetPagination<Map<String, dynamic>>(url,
            queryParameters: queryParams);
    if (response == null) {
      throw "Error getting pagination for data sync";
    }
    return Pagination.fromMap(response["pager"]);
  }

  Future<D?> getData<D>(int page) async {
    Map<String, String> updatedParams = {
      ...queryParams,
      "page": page.toString()
    };
    return await client!.httpGet<D>(url, queryParameters: updatedParams);
  }

  Future downloadPage(int page) async {
    Map<String, dynamic>? data = await getData<Map<String, dynamic>>(page);
    if (data == null) {
      throw "Error getting data for page $page";
    }
    List<Map<String, dynamic>> entityData =
        data[dataKey ?? resource].cast<Map<String, dynamic>>();

    List<T> entities = entityData.map(mapper).toList();

    await box.putManyAsync(entities);
  }

  Future initializeDownload() async {
    try {
      D2SyncStatus status =
          D2SyncStatus(status: D2SyncStatusEnum.initialized, label: label);
      downloadController.add(status);
      Pagination pagination = await getPagination();
      status.setTotal(pagination.pageCount);
      downloadController.add(status);
      status.updateStatus(D2SyncStatusEnum.syncing);
      for (int page = 1; page <= pagination.pageCount; page++) {
        await downloadPage(page);
        downloadController.add(status.increment());
      }
      downloadController.add(status.complete());
      downloadController.close();
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
    if (client == null) {
      throw "DHIS2 client not found. Make sure you call setClient first";
    }
    return await initializeDownload();
  }
}
