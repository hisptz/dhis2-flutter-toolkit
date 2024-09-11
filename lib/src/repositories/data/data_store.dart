import 'dart:convert';

import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/data/base.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/data/download_mixin/data_store_data_download_service_mixin.dart';
import 'package:flutter/foundation.dart';

import '../../../objectbox.g.dart';

class D2DataStoreRepository extends BaseDataRepository
    with D2DataStoreDataDownloadServiceMixin {
  String? namespace;

  Condition<D2DataStore>? conditions;

  Box<D2DataStore> get box {
    return db.store.box<D2DataStore>();
  }

  D2DataStoreRepository(super.db, {this.namespace})
      : conditions =
            namespace != null ? D2DataStore_.namespace.equals(namespace) : null;

  List<String> get keys {
    List<D2DataStore> stores = box.query(conditions).build().find();
    return stores.map((store) => store.key).toList();
  }

  setNamespace(String namespace) {
    this.namespace = namespace;
  }

  D2DataStore? getByKey(String key) {
    if (namespace == null) {
      throw "You must set the namespace first";
    }
    return box
        .query(conditions?.and(D2DataStore_.key.equals(key)))
        .build()
        .findFirst();
  }

  int? getIdByUid(String uid) {
    return box.query(D2DataStore_.uid.equals(uid)).build().findFirst()?.id;
  }

  uploadLogsToDataStore(String namespace, D2ClientService client) async {
    // Fetch logs as map
    List<Map> logs = D2AppLogRepository(db).getAllLogsAsMap();

    // Prepare the payload to send
    String key = client.credentials.username;
    String payload = jsonEncode(logs);
    D2DataStore logDataStore =
        D2DataStore.fromMap(db, namespace: namespace, key: key, value: logs);
    box.put(logDataStore);
    try {
      Map response =
          await client.httpPost("dataStore/$namespace/$key", payload);
        if (response.containsKey("httpStatus")) {
          if (response["httpStatus"] == "OK") {
            if (kDebugMode) {
              print("Logs uploaded successfully");
            }
          } else {
            response =
                await client.httpPut("dataStore/$namespace/$key", payload);
          }
        }
    } catch (e) {
      if (kDebugMode) {
        print("Failed to upload logs: $e");
      }
    }
  }
}
