import 'dart:async';

import 'package:dhis2_flutter_toolkit/src/repositories/data/base_aggregate.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/data/query_mixin/base_aggregate_query_mixin.dart';
import 'package:objectbox/objectbox.dart';

import '../../../models/data/base.dart';
import '../../../services/entry.dart';
import '../../../utils/entry.dart';

mixin BaseAggregateDataUploadServiceMixin<T extends SyncDataSource>
    on D2BaseAggregateRepository<T>, D2BaseAggregateQueryMixin<T> {
  D2ClientService? client;
  int uploadPageSize = 100;
  abstract String uploadResource;
  abstract String label;
  abstract String uploadDataKey;

  StreamController<D2SyncStatus> uploadController =
      StreamController<D2SyncStatus>();

  Query<T> getUnSyncedQuery();

  get uploadURL {
    return uploadResource;
  }

  get uploadStream {
    return uploadController.stream;
  }

  BaseAggregateDataUploadServiceMixin<T> setupUpload(D2ClientService client,
      {int? pageSize}) {
    this.client = client;
    if (pageSize != null) {
      this.uploadPageSize = pageSize;
    }
    return this;
  }

  Future uploadPage({required int page, required Query<T> query}) async {
    Query<T> localQuery = query;
    localQuery
      ..offset = (page * uploadPageSize)
      ..limit = uploadPageSize;
    List<T> entities = await localQuery.findAsync();
    List<Map<String, dynamic>> entityPayload =
        await Future.wait(entities.map((entity) => entity.toMap(db: db)));

    Map<String, dynamic> payload = {uploadDataKey: entityPayload};
    Map<String, dynamic> response =
        await client!.httpPost<Map<String, dynamic>>(
      uploadURL,
      payload,
    );

    if (response['httpStatusCode'] == 200) {
      for (T element in entities) {
        element.synced = true;
      }
      await box.putManyAsync(entities);
    } else {
      ///Data sync status will not be updated
      //TODO: Find a way to handle issues here
    }

    return response;
  }

  Future upload() async {
    if (client == null) {
      throw "Error starting upload. Make sure you call setClient first";
    }
    try {
      uploadController.stream.listen(null);
      Query<T> query = getUnSyncedQuery();
      int count = query.count();
      if (count == 0) {
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
          label: label);
      uploadController.add(status);
      status.updateStatus(D2SyncStatusEnum.syncing);
      for (int page = 0; page < pages; page++) {
        await uploadPage(page: page, query: query);
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
}
