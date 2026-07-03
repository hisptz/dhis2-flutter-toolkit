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
    : conditions = namespace != null
          ? D2DataStore_.namespace.equals(namespace)
          : null;

  List<String> get keys {
    List<D2DataStore> stores = box.query(conditions).build().find();
    return stores.map((store) => store.key).toList();
  }

  setNamespace(String namespace) {
    this.namespace = namespace;
    conditions = D2DataStore_.namespace.equals(namespace);
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

  List<D2DataStore> getAll() {
    return box.query(conditions).build().find();
  }

  List<String> getKeys() {
    return box.query(conditions).build().property(D2DataStore_.key).find();
  }

  int? getIdByUid(String uid) {
    return box.query(D2DataStore_.uid.equals(uid)).build().findFirst()?.id;
  }



uploadLogsToDataStore(String namespace, D2ClientService client) async {
  List<Map> logs = D2AppLogRepository(db).getAllLogsAsMap();
  String key = client.credentials.username.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');

  D2DataStore logDataStore =
      D2DataStore.fromMap(db, namespace: namespace, key: key, value: logs);
  box.put(logDataStore);

  try {
    List<Map> existingLogsInDatastore = [];
    bool keyExists = false;

    try {
      dynamic dataStoreResponse = await client.httpGet("dataStore/$namespace/$key");
      if (dataStoreResponse is List) {
        existingLogsInDatastore = dataStoreResponse
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
        keyExists = true;
      }
    } catch (_) {
      keyExists = false;
    }

    Map<String, Map> mergedMap = {};

    for (var log in existingLogsInDatastore) {
      final id = log['id']?.toString();
      if (id != null) mergedMap[id] = log;
    }

    for (var log in logs) {
      final id = log['id']?.toString();
      if (id != null) mergedMap[id] = log;
    }

    List<Map> mergedLogs = mergedMap.values.toList();

    List jsonPayload = jsonDecode(jsonEncode(mergedLogs));
    Map response;

    if (keyExists) {
      response = await client.httpPut("dataStore/$namespace/$key", jsonPayload);
    } else {
      response = await client.httpPost("dataStore/$namespace/$key", jsonPayload);
    }

    String httpStatus = response["httpStatus"]?.toString() ?? "Unknown";
    String message = response["message"]?.toString() ?? "No message";

    if (httpStatus != "OK") {
      throw Exception("Upload failed: $message");
    }
  } catch (e) {
    if(kDebugMode){
      print("Error uploading logs to DataStore: $e");
    }
  }
}}