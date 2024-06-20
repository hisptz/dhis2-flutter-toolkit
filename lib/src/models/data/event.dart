import 'dart:convert';

import 'package:dhis2_flutter_toolkit/src/models/data/base_deletable.dart';
import 'package:dhis2_flutter_toolkit/src/models/data/base_editable.dart';
import 'package:dhis2_flutter_toolkit/src/utils/uid.dart';
import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import '../../repositories/data/entry.dart';
import '../../repositories/metadata/entry.dart';
import '../../ui/form_components/entry.dart';
import '../metadata/entry.dart';
import 'base.dart';
import 'entry.dart';
import 'upload_base.dart';

@Entity()

/// This class represents an event in the DHIS2 system, implementing various interfaces for syncing, editing, and deletion.
class D2Event extends SyncDataSource
    implements SyncableData, D2BaseEditable, D2BaseDeletable {
  /// The unique identifier of the event.
  @override
  int id = 0;

  /// The creation timestamp of the event.
  @override
  DateTime createdAt;

  /// The last updated timestamp of the event.
  @override
  DateTime updatedAt;

  /// The UID of the event.
  @override
  String uid;

  /// The scheduled timestamp of the event.
  DateTime? scheduledAt;

  /// The occurred timestamp of the event.
  DateTime? occurredAt;

  /// The status of the event.
  String status;

  /// The attribute category options associated with the event.
  String? attributeCategoryOptions;

  /// Indicates whether the event is deleted.
  bool deleted;

  /// Indicates whether the event is marked for follow-up.
  bool followup;

  /// The attribute option combo associated with the event.
  String? attributeOptionCombo;

  /// Notes associated with the event.
  String? notes;

  /// The geometry of the event in serialized JSON format.
  String? geometry;

  /// The relationships associated with the event.
  @Backlink("fromEvent")
  final relationships = ToMany<D2Relationship>();

  /// The data values associated with the event.
  @Backlink("event")
  final dataValues = ToMany<D2DataValue>();

  /// Additional data values for querying.
  final dataValuesForQuery = ToMany<D2DataValue>();

  /// The enrollment associated with the event.
  final enrollment = ToOne<D2Enrollment>();

  /// The tracked entity associated with the event.
  final trackedEntity = ToOne<D2TrackedEntity>();

  /// The program associated with the event.
  final program = ToOne<D2Program>();

  /// The program stage associated with the event.
  final programStage = ToOne<D2ProgramStage>();

  /// The organizational unit associated with the event.
  final orgUnit = ToOne<D2OrgUnit>();

  /// Constructs a new instance of the [D2Event] class.
  ///
  /// - [attributeCategoryOptions]: The attribute category options associated with the event.
  /// - [attributeOptionCombo]: The attribute option combo associated with the event.
  /// - [updatedAt]: The last updated timestamp of the event.
  /// - [createdAt]: The creation timestamp of the event.
  /// - [followup]: Indicates whether the event is marked for follow-up.
  /// - [deleted]: Indicates whether the event is deleted.
  /// - [status]: The status of the event.
  /// - [notes]: Notes associated with the event.
  /// - [scheduledAt]: The scheduled timestamp of the event.
  /// - [uid]: The UID of the event.
  /// - [occurredAt]: The occurred timestamp of the event.
  /// - [synced]: Indicates whether the event is synced.
  /// - [geometry]: The geometry of the event in serialized JSON format.
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

  /// Constructs a new instance of the [D2Event] class from a JSON map.
  ///
  /// - [db]: The ObjectBox database instance.
  /// - [json]: The JSON map representing the event.
  ///
  /// The constructor performs the following initializations:
  /// - Assigns values to [attributeCategoryOptions], [attributeOptionCombo],
  ///   [updatedAt], [createdAt], [followup], [deleted], [status], [synced],
  ///   [notes], [scheduledAt], [uid], [geometry], and [occurredAt].
  /// - Retrieves the event ID from the repository using the event UID.
  /// - Sets up the [enrollment], [trackedEntity], [program], [programStage],
  ///   and [orgUnit] relationships by querying their respective repositories
  ///   with the provided UIDs in the JSON map.
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
  }

  /// Constructs a new instance of the [D2Event] class from form values [formValues].
  ///
  /// - [formValues]: The form values representing the event.
  /// - [db]: The ObjectBox database instance.
  /// - [enrollment]: The enrollment associated with the event.
  /// - [programStage]: The program stage associated with the event.
  /// - [orgUnit]: The organizational unit associated with the event.
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

  /// Whether the event is synced.
  @override
  bool synced;

  /// Converts the event to a map for JSON serialization.
  ///
  /// - [db]: The ObjectBox database instance.
  /// - Returns: A map representing the event.
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

  /// Converts the [D2Event] instance into a map of form values.
  ///
  /// Includes the event's occurrence date, organization unit ID, data values,
  /// and geometry information if available.
  ///
  /// Returns a [Map<String, dynamic>] of the form values.
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

  /// Updates the [D2Event] instance with values from a form.
  ///
  /// Parameters:
  /// - [values]: A map containing form values.
  /// - [db]: An instance of [D2ObjectBox].
  /// - [program]: An optional [D2Program] instance.
  /// - [orgUnit]: An optional [D2OrgUnit] instance.
  @override
  void updateFromFormValues(Map<String, dynamic> values,
      {required D2ObjectBox db, D2Program? program, D2OrgUnit? orgUnit}) {
    if (orgUnit != null) {
      this.orgUnit.target = orgUnit;
    }
    occurredAt = DateTime.tryParse(values["occurredAt"]) ?? occurredAt;
    for (D2DataValue dataValue in dataValues) {
      dataValue.updateFromFormValues(values, db: db);
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

  /// Saves the [D2Event] instance to the database.
  ///
  /// Parameters:
  /// - [db]: An instance of [D2ObjectBox].
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

  /// Deletes the [D2Event] instance from the database along with associated data values and relationships.
  ///
  /// Parameters:
  /// - [db]: An instance of [D2ObjectBox].
  ///
  /// Returns [bool] whether the deletion was successful.
  @override
  bool delete(D2ObjectBox db) {
    D2DataValueRepository(db).deleteEntities(dataValues);
    for (D2Relationship relationship in relationships) {
      relationship.delete(db);
    }
    return D2EventRepository(db).deleteEntity(this);
  }

  /// Soft deletes the [D2Event] instance by marking it as deleted and saving the changes.
  ///
  /// Parameters:
  /// - [db]: An instance of [D2ObjectBox].
  @override
  void softDelete(db) {
    deleted = true;
    save(db);
  }
}
