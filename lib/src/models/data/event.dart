import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dhis2_flutter_toolkit/src/models/data/base_deletable.dart';
import 'package:dhis2_flutter_toolkit/src/models/data/base_editable.dart';
import 'package:objectbox/objectbox.dart';

import '../../../dhis2_flutter_toolkit.dart';
import 'base.dart';
import 'upload_base.dart';

@Entity()
class D2Event extends SyncDataSource
    implements SyncableData, D2BaseEditable, D2BaseDeletable {
  @override
  int id = 0;
  @override
  DateTime createdAt;

  @override
  DateTime updatedAt;

  @Unique()
  @override
  String uid;
  DateTime? scheduledAt;
  DateTime? occurredAt;
  String status;
  String? attributeCategoryOptions;
  bool deleted;
  bool followup;
  String? attributeOptionCombo;
  String? notes;

  String? geometry;

  @Backlink("fromEvent")
  final relationships = ToMany<D2Relationship>();

  @Backlink("toEvent")
  final toRelationships = ToMany<D2Relationship>();

  @Backlink("event")
  final dataValues = ToMany<D2DataValue>();

  final dataValuesForQuery = ToMany<D2DataValue>();
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
      this.synced,
      this.geometry);

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
        geometry =
            json["geometry"] != null ? jsonEncode(json["geometry"]) : null,
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

    List<D2DataValue> values = json["dataValues"]
        ?.map<D2DataValue>(
            (dataValue) => D2DataValue.fromMap(db, dataValue, uid))
        .toList();

    dataValues.addAll(values);
  }

  D2Event.fromFormValues(Map<String, dynamic> formValues,
      {required D2ObjectBox db,
      D2Enrollment? enrollment,
      required D2ProgramStage programStage,
      required D2OrgUnit orgUnit})
      : updatedAt = DateTime.now(),
        createdAt = DateTime.now(),
        followup = false,
        deleted = false,
        status = formValues["status"] ?? "COMPLETED",
        synced = false,
        uid = D2UID.generate(),
        occurredAt = DateTime.tryParse(formValues["occurredAt"] ?? "") ??
            DateTime.now() {
    if (enrollment != null) {
      this.enrollment.target = enrollment;
      trackedEntity.target = enrollment.trackedEntity.target;
      if (enrollment.program.targetId != programStage.program.targetId) {
        throw 'Enrollment program ${enrollment.program.target!.displayName} is not the same as the specified program of the program stage ${programStage.program.target!.displayName}';
      }
    }

    program.target = programStage.program.target;
    this.programStage.target = programStage;
    this.orgUnit.target = orgUnit;

    List<D2DataValue> dataValues = programStage.programStageDataElements
        .map((pDataElement) => pDataElement.dataElement.target!)
        .toList()
        .map((D2DataElement dataElement) {
      String? value = formValues[dataElement.uid];
      return D2DataValue.fromFormValues(value,
          event: this, dataElement: dataElement);
    }).toList();

    this.dataValues.addAll(dataValues);

    if (formValues["geometry"] != null) {
      var geometryValue = formValues["geometry"];

      ///A form has geometry. This should be inserted as a serialized JSON
      if (geometryValue is D2GeometryValue) {
        Map<String, dynamic> geometry = geometryValue.toGeoJson();
        String geometryString = jsonEncode(geometry);
        this.geometry = geometryString;
      }
    }
  }

  @override
  bool synced;

  D2DataValue? getDataValue(String dataElementId) {
    return dataValues.firstWhereOrNull(
        (dataValue) => dataValue.dataElement.target?.uid == dataElementId);
  }

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

    if (geometry != null) {
      payload.addAll({"geometry": jsonDecode(geometry!)});
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

    if (geometry != null) {
      Map<String, dynamic> geometryObject = jsonDecode(geometry!);
      data.addAll({"geometry": D2GeometryValue.fromGeoJson(geometryObject)});
    }

    return data;
  }

  void updateFromFormValues(Map<String, dynamic> values,
      {required D2ObjectBox db, D2OrgUnit? orgUnit}) {
    if (orgUnit != null) {
      this.orgUnit.target = orgUnit;
    }
    occurredAt = DateTime.tryParse(values["occurredAt"]) ?? occurredAt;
    for (D2ProgramStageDataElement d2programStageDataElement
        in programStage.target!.programStageDataElements) {
      D2DataElement d2dataElement =
          d2programStageDataElement.dataElement.target!;
      D2DataValue? existingDataValue = dataValues.firstWhereOrNull(
          (dataValue) => dataValue.dataElement.targetId == d2dataElement.id);

      if (existingDataValue != null) {
        existingDataValue.updateFromFormValues(values, db: db);
      } else {
        String? value = values[d2dataElement.uid];
        dataValues.add(D2DataValue.fromFormValues(value,
            event: this, dataElement: d2dataElement));
      }
    }

    if (values["geometry"] != null) {
      var geometryValue = values["geometry"];

      ///A form has geometry. This should be inserted as a serialized JSON
      if (geometryValue is D2GeometryValue) {
        Map<String, dynamic> geometry = geometryValue.toGeoJson();
        String geometryString = jsonEncode(geometry);
        this.geometry = geometryString;
      }
    }
    synced = false;
  }

  @override
  void save(D2ObjectBox db) {
    if (id == 0) {
      id = D2EventRepository(db).saveEntity(this);
    } else {
      D2EventRepository(db).saveEntity(this);
      for (D2DataValue dataValue in dataValues) {
        dataValue.save(db);
      }
    }
  }

  @override
  bool delete(D2ObjectBox db) {
    //Deletes event and all associated data values & relationships
    D2DataValueRepository(db).deleteEntities(dataValues);
    for (D2Relationship relationship in relationships) {
      relationship.delete(db);
    }
    return D2EventRepository(db).deleteEntity(this);
  }

  @override
  void softDelete(db) {
    deleted = true;
    save(db);
  }

  Future<void> upload(
      {required D2ClientService client, required D2ObjectBox db}) async {
    return D2EventRepository(db).setupUpload(client).uploadOne(this);
  }
}
