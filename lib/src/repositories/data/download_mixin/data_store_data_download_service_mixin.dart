import 'dart:async';

import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/data/base.dart';
import 'package:flutter/foundation.dart';

import '../../../models/data/data_store.dart';
import '../../../services/client/client.dart';
import '../../../utils/sync_status.dart';

mixin D2DataStoreDataDownloadServiceMixin on BaseDataRepository {
  String downloadURL = "dataStore";
  D2ClientService? client;

  StreamController<D2SyncStatus> downloadController =
      StreamController<D2SyncStatus>();

  get downloadStream {
    return downloadController.stream;
  }

  setupDownload({required D2ClientService client}) {
    this.client = client;
  }

  Future<List?> getKeysFromNamespace(String namespace) async {
    return client!.httpGet<List>("$downloadURL/$namespace");
  }

  downloadNamespaceData(String namespace,
      {required D2SyncStatus status}) async {
    D2SyncStatus childStatus =
        D2SyncStatus(status: D2SyncStatusEnum.initialized, label: namespace);
    status.subProcess = childStatus;
    downloadController.add(status);
    List keys = await getKeysFromNamespace(namespace) ?? [];

    if (keys.isEmpty) {
      return;
    }

    status.subProcess?.setTotal(keys.length);
    downloadController.add(status);
    List<D2DataStore> stores = [];
    for (String key in keys) {
      String url = "$downloadURL/$namespace/$key";
      var response = await client!.httpGet(url);
      if (response is Object) {
        D2DataStore store = D2DataStore.fromMap(namespace, key, response);
        stores.add(store);
      } else {
        if (kDebugMode) {
          print("$response is not a valid Object");
        }
      }
      status.subProcess?.increment();
      downloadController.add(status);
    }
    await db.store.box<D2DataStore>().putManyAsync(stores);
  }

  initializeDownload({required List<String> namespaces}) async {
    if (client == null) {
      throw "Client not set. You need to call setupDownload first";
    }
    if (namespaces.isEmpty) {
      return;
    }
    try {
      D2SyncStatus status = D2SyncStatus(
          status: D2SyncStatusEnum.initialized, label: "Data store");
      status.setTotal(namespaces.length);
      status.updateStatus(D2SyncStatusEnum.syncing);
      downloadController.add(status);
      for (String namespace in namespaces) {
        await downloadNamespaceData(namespace, status: status);
        status.subProcess = null;
        status.increment();
        downloadController.add(status);
      }
      downloadController.add(status.complete());
      await downloadController.close();
    } catch (e) {
      downloadController.addError(e);
      rethrow;
    }
  }
}
