import 'dart:async';

import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';

import '../../../objectbox.dart';
import '../../../objectbox.g.dart';
import '../../models/data/reserved_value.dart';
import '../../models/metadata/tracked_entity_attribute.dart';
import '../../services/client/client.dart';
import '../../utils/sync_status.dart';
import '../metadata/tracked_entity_attribute.dart';

class D2ReservedValueRepository {
  D2ObjectBox db;
  D2ClientService? client;

  Box<D2ReservedValue> get box {
    return db.store.box<D2ReservedValue>();
  }

  D2ReservedValueRepository(this.db);

  StreamController<D2SyncStatus> downloadController =
      StreamController<D2SyncStatus>();

  setupDownload({required D2ClientService client}) {
    this.client = client;
  }

  get downloadStream {
    return downloadController.stream;
  }

  Future downloadAllReservedValues(
      {required int numberToReserve, String? orgUnitCode}) async {
    if (client == null) {
      throw "You need to call setupDownload first";
    }
    D2SyncStatus status = D2SyncStatus(
        status: D2SyncStatusEnum.initialized, label: "Reserved Values");

    downloadController.add(status);

    Query<D2TrackedEntityAttribute> query =
        D2TrackedEntityAttributeRepository(db)
            .box
            .query(D2TrackedEntityAttribute_.generated.equals(true))
            .build();
    List<D2TrackedEntityAttribute> attributes = await query.findAsync();

    status.setTotal(attributes.length);
    status.updateStatus(D2SyncStatusEnum.syncing);
    downloadController.add(status);
    try {
      for (D2TrackedEntityAttribute attribute in attributes) {
        await downloadReservedValues(
            numberToReserve: numberToReserve,
            owner: attribute,
            orgUnitCode: orgUnitCode);
        status.increment();
        downloadController.add(status);
      }
    } catch (e) {
      downloadController.addError(e);
      rethrow;
    } finally {
      downloadController.close();
    }
  }

  Future downloadReservedValues(
      {required int numberToReserve,
      required D2TrackedEntityAttribute owner,
      String? orgUnitCode}) async {
    if (client == null) {
      throw "You need to call setupDownload first";
    }
    String url = 'trackedEntityAttributes/${owner.uid}/generateAndReserve';

    Map<String, String> params = {
      "numberToReserve": numberToReserve.toString()
    };

    if (orgUnitCode != null) {
      params.addAll({'ORG_UNIT_CODE': orgUnitCode});
    }

    List? response = await client!.httpGet<List>(url, queryParameters: params);
    if (response != null) {
      List<D2ReservedValue> reservedValues = response
          .map<D2ReservedValue>((value) => D2ReservedValue.fromMap(db, value))
          .toList();
      await box.putManyAsync(reservedValues);
    } else {
      throw "Error downloading reserved value for attribute ${owner.displayName}";
    }
  }

  D2ReservedValue? getReservedValue({required D2TrackedEntityAttribute owner}) {
    Query<D2ReservedValue> query = box
        .query(D2ReservedValue_.trackedEntityAttribute
            .equals(owner.id)
            .and(D2ReservedValue_.expiresOn.greaterThanDate(DateTime.now())))
        .build();
    return query.findFirst();
  }
}
