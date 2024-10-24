import 'dart:async';

import '../../../objectbox.dart';
import '../../../objectbox.g.dart';
import '../../models/data/entry.dart';
import '../../models/metadata/entry.dart';
import '../../services/client/client.dart';
import '../../utils/sync_status.dart';
import '../metadata/entry.dart';

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

  Future downloadAllReservedValues({required int numberToReserve}) async {
    if (client == null) {
      throw "You need to call setupDownload first";
    }
    await deleteExpiredValues();
    D2SyncStatus status = D2SyncStatus(
        status: D2SyncStatusEnum.initialized, label: "Reserved Values");

    downloadController.add(status);

    QueryBuilder<D2ProgramTrackedEntityAttribute> queryBuilder =
        D2ProgramTrackedEntityAttributeRepository(db).box.query();

    queryBuilder.link(D2ProgramTrackedEntityAttribute_.trackedEntityAttribute,
        D2TrackedEntityAttribute_.generated.equals(true));
    Query<D2ProgramTrackedEntityAttribute> query = queryBuilder.build();
    List<D2ProgramTrackedEntityAttribute> attributes = await query.findAsync();

    status.setTotal(attributes.length);
    status.updateStatus(D2SyncStatusEnum.syncing);
    downloadController.add(status);
    try {
      for (D2ProgramTrackedEntityAttribute attribute in attributes) {
        D2TrackedEntityAttribute owner =
            attribute.trackedEntityAttribute.target!;
        String pattern = owner.pattern!;

        if (isOrgUnitDependent(pattern)) {
          D2User? user = D2UserRepository(db).get();
          if (user == null) {
            throw "Error getting active user. Refresh the application";
          }

          List<D2OrgUnit> userOrgUnits = user.organisationUnits
              .map((String orgUnitId) =>
                  D2OrgUnitRepository(db).getByUid(orgUnitId)!)
              .toList();

          List<D2OrgUnit> orgUnits = attribute.program.target!.organisationUnits
              .where((D2OrgUnit programOrgUnit) {
            return userOrgUnits.any((userOrgUnit) {
              return userOrgUnit.id == programOrgUnit.id ||
                  programOrgUnit.path.contains(userOrgUnit.uid);
            });
          }).toList();

          D2SyncStatus subStatus = D2SyncStatus(
              status: D2SyncStatusEnum.initialized,
              label: "Org unit reserved values");

          subStatus.setTotal(orgUnits.length);
          status.subProcess = subStatus;
          downloadController.add(status);

          for (D2OrgUnit orgUnit in orgUnits) {
            await downloadReservedValues(
                numberToReserve: numberToReserve,
                owner: owner,
                orgUnit: orgUnit);
            status.subProcess!.increment();
            downloadController.add(status);
          }
          status.subProcess = null;
          downloadController.add(status);
        } else {
          await downloadReservedValues(
              numberToReserve: numberToReserve, owner: owner);
        }

        status.increment();
        downloadController.add(status);
      }
      downloadController.add(status.complete());
      await downloadController.close();
    } catch (e) {
      downloadController.addError(e);
      rethrow;
    } finally {
      downloadController.close();
    }
  }

  bool isOrgUnitDependent(String pattern) {
    return pattern.contains("ORG_UNIT_CODE");
  }

  Future deleteExpiredValues() async {
    QueryBuilder<D2ReservedValue> queryBuilder =
        box.query(D2ReservedValue_.expiresOn.lessOrEqualDate(DateTime.now()));
    List<D2ReservedValue> values = await queryBuilder.build().findAsync();
    await box.removeManyAsync(values.map((value) => value.id).toList());
  }

  Future downloadReservedValues(
      {required int numberToReserve,
      required D2TrackedEntityAttribute owner,
      D2OrgUnit? orgUnit}) async {
    if (client == null) {
      throw "You need to call setupDownload first";
    }

    String url = 'trackedEntityAttributes/${owner.uid}/generateAndReserve';

    Map<String, String> params = {
      "numberToReserve": numberToReserve.toString()
    };

    if (orgUnit != null) {
      if (orgUnit.code != null) {
        params.addAll({'ORG_UNIT_CODE': orgUnit.code!});
      }
    }

    List? response = await client!.httpGet<List>(url, queryParameters: params);
    if (response != null) {
      List<D2ReservedValue> reservedValues = response
          .map<D2ReservedValue>(
              (value) => D2ReservedValue.fromMap(db, value, orgUnit: orgUnit))
          .toList();
      await box.putManyAsync(reservedValues);
    } else {
      throw "Error downloading reserved value for attribute ${owner.displayName}";
    }
  }

  D2ReservedValue? getReservedValue(
      {required D2ProgramTrackedEntityAttribute owner,
      required D2OrgUnit orgUnit}) {
    Condition<D2ReservedValue> queryCondition = D2ReservedValue_
        .trackedEntityAttribute
        .equals(owner.trackedEntityAttribute.target!.id)
        .and(D2ReservedValue_.assigned.equals(false))
        .and(D2ReservedValue_.expiresOn.greaterThanDate(DateTime.now()));

    String pattern = owner.trackedEntityAttribute.target!.pattern!;
    if (isOrgUnitDependent(pattern)) {
      queryCondition.and(D2ReservedValue_.orgUnit.equals(orgUnit.id));
    }

    Query<D2ReservedValue> query = box.query(queryCondition).build();
    return query.findFirst();
  }

  void setValueAsAssigned(D2ReservedValue value) {
    value.assigned = true;
    box.put(value);
  }

  Future<void> saveEntities(List<D2ReservedValue> values) async {
    await box.putManyAsync(values);
  }
}
