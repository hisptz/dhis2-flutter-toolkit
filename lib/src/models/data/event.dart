import 'dart:convert';

import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/models/data/base_editable.dart';
import 'package:objectbox/objectbox.dart';

import 'base.dart';
import 'upload_base.dart';

@Entity()
class D2Event extends SyncDataSource implements SyncableData, D2BaseEditable {
  @override
  int id = 0;
  @override
  DateTime createdAt;

  @override
  DateTime updatedAt;

  @override
  String uid;
  DateTime? scheduledAt;
  DateTime? occurredAt;
  String status;
  String attributeCategoryOptions;
  bool deleted;
  bool followup;
  String attributeOptionCombo;
  String? notes;

  //Disabled for now
  // @Backlink("event")
  // final relationships = ToMany<D2Relationship>();

  @Backlink("event")
  final dataValues = ToMany<D2DataValue>();
  final enrollment = ToOne<D2Enrollment>();
  final trackedEntity = ToOne<D2TrackedEntity>();
  final program = ToOne<D2Program>();
  final programStage = ToOne<D2ProgramStage>();
  final orgUnit = ToOne<D2OrgUnit>();

  D2Event(
      this.attributeCategoryOptions,
      this.attributeOptionCombo,
      this.updatedAt,
      this.createdAt,
      this.followup,
      this.deleted,
      this.status,
      this.notes,
      this.scheduledAt,
      this.uid,
      this.occurredAt,
      this.synced);

  D2Event.fromMap(D2ObjectBox db, Map json)
      : attributeCategoryOptions = json["attributeCategoryOptions"],
        attributeOptionCombo = json["attributeOptionCombo"],
        updatedAt = DateTime.parse(json["updatedAt"]),
        createdAt = DateTime.parse(json["createdAt"]),
        followup = json["followup"],
        deleted = json["deleted"],
        status = json["status"],
        synced = true,
        notes = jsonEncode(json["notes"]),
        scheduledAt = DateTime.tryParse(json["scheduledAt"] ?? ""),
        uid = json["event"],
        occurredAt = DateTime.tryParse(json["occurredAt"] ?? "") {
    id = D2EventRepository(db).getIdByUid(json["event"]) ?? 0;

    if (json["enrollment"] != null) {
      enrollment.target =
          D2EnrollmentRepository(db).getByUid(json["enrollment"]);
    }

    if (json["trackedEntity"] != null) {
      trackedEntity.target =
          D2TrackedEntityRepository(db).getByUid(json["trackedEntity"]);
    }

    program.target = D2ProgramRepository(db).getByUid(json["program"]);
    programStage.target =
        D2ProgramStageRepository(db).getByUid(json["programStage"]);
    orgUnit.target = D2OrgUnitRepository(db).getByUid(json["orgUnit"]);
  }

  @override
  bool synced;

  @override
  Future<Map<String, dynamic>> toMap({D2ObjectBox? db}) async {
    if (db == null) {
      throw "ObjectBox instance is required";
    }

    List<Map<String, dynamic>> dataValuesPayload = await Future.wait(dataValues
        .map<Future<Map<String, dynamic>>>((e) => e.toMap())
        .toList());

    Map<String, dynamic> payload = {
      "scheduledAt": scheduledAt?.toIso8601String(),
      "program": program.target?.uid,
      "event": uid,
      "programStage": programStage.target?.uid,
      "orgUnit": orgUnit.target?.uid,
      "enrollmentStatus": status,
      "status": status,
      "occurredAt": occurredAt?.toIso8601String(),
      "attributeCategoryOptions": attributeCategoryOptions,
      "deleted": deleted,
      "attributeOptionCombo": attributeOptionCombo,
      "dataValues": dataValuesPayload,
    };

    // Check if event does have an enrollment link
    if (enrollment.target?.id != 0) {
      payload["enrollment"] = enrollment.target?.uid;
    }
    // Check if event does have an trackedEntity link
    if (trackedEntity.target?.id != 0) {
      payload["trackedEntity"] = trackedEntity.target?.uid;
    }

    return payload;
  }

  @override
  Map<String, dynamic> toFormValues() {
    Map<String, dynamic> data = {
      "occurredAt": occurredAt?.toIso8601String(),
      "orgUnit": orgUnit.target?.uid
    };

    for (var element in dataValues) {
      data.addAll(element.toFormValues());
    }

    return data;
  }

  @override
  void updateFromFormValues(Map<String, dynamic> values,
      {required D2ObjectBox db, D2OrgUnit? orgUnit}) {
    if (orgUnit != null) {
      this.orgUnit.target = orgUnit;
    }
    occurredAt = DateTime.tryParse(values["occurredAt"]) ?? occurredAt;
    for (D2DataValue dataValue in dataValues) {
      dataValue.updateFromFormValues(values, db: db);
    }
    synced = false;
  }

  void save(D2ObjectBox db) {
    id = D2EventRepository(db).saveEntity(this);
  }
}
