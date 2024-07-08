import 'dart:convert';

import 'package:dhis2_flutter_toolkit/src/models/data/base_deletable.dart';
import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import '../../repositories/data/entry.dart';
import '../../repositories/metadata/entry.dart';
import '../../ui/form_components/entry.dart';
import '../../utils/entry.dart';
import '../metadata/entry.dart';
import 'base.dart';
import 'base_editable.dart';
import 'event.dart';
import 'relationship.dart';
import 'tracked_entity.dart';
import 'upload_base.dart';

@Entity()

/// This class represents an enrollment in the DHIS2 system.
class D2Enrollment extends SyncDataSource
    implements SyncableData, D2BaseEditable, D2BaseDeletable {
  /// Unique identifier for the enrollment.
  @override
  int id = 0;

  /// Date and time when the enrollment was created.
  @override
  DateTime createdAt;

  /// Date and time when the enrollment was last updated.
  @override
  DateTime updatedAt;

  /// Unique identifier for the enrollment.
  @override
  @Unique()
  String uid;

  /// Date when the enrollment was started.
  DateTime enrolledAt;

  /// Indicates if the enrollment has been deleted.
  bool deleted;

  /// Indicates if follow-up is required for the enrollment.
  bool followup;

  /// Date when the enrollment event occurred.
  DateTime occurredAt;

  /// Current status of the enrollment.
  String status;

  /// Additional notes related to the enrollment.
  String? notes;

  /// JSON string representation of the geometry associated with the enrollment.
  String? geometry;

  /// Backlink to events associated with this enrollment.
  @Backlink("enrollment")
  final events = ToMany<D2Event>();

  /// Backlink to relationships associated with this enrollment.
  @Backlink("fromEnrollment")
  final relationships = ToMany<D2Relationship>();

  /// To-one relation to the tracked entity associated with this enrollment.
  final trackedEntity = ToOne<D2TrackedEntity>();

  /// To-one relation to the organization unit associated with this enrollment.
  final orgUnit = ToOne<D2OrgUnit>();

  /// To-one relation to the program associated with this enrollment.
  final program = ToOne<D2Program>();

  get orgUnitName {
    return orgUnit.target?.name;
  }

  /// Constructor for creating an instance of [D2Enrollment].
  /// Parameters:
  /// - [uid] Unique identifier for the enrollment.
  /// - [updatedAt] Date and time when the enrollment was last updated.
  /// - [createdAt] Date and time when the enrollment was created.
  /// - [enrolledAt] Date when the enrollment was started.
  /// - [followup] Whether follow-up is required for the enrollment.
  /// - [deleted] Whether the enrollment has been deleted.
  /// - [occurredAt] Date when the enrollment event occurred.
  /// - [status] Current status of the enrollment.
  /// - [notes] Additional notes related to the enrollment.
  /// - [synced] Whether the enrollment has been synced with the server.
  /// - [geometry] JSON string representation of the geometry associated with the enrollment.
  D2Enrollment(
      this.uid,
      this.updatedAt,
      this.createdAt,
      this.enrolledAt,
      this.followup,
      this.deleted,
      this.occurredAt,
      this.status,
      this.notes,
      this.synced,
      this.geometry);

  /// Constructor that creates an instance of [D2Enrollment] from a JSON [json].
  D2Enrollment.fromMap(D2ObjectBox db, Map json)
      : uid = json["enrollment"],
        updatedAt = DateTime.parse(json["updatedAt"]),
        createdAt = DateTime.parse(json["createdAt"]),
        enrolledAt = DateTime.parse(json["enrolledAt"]),
        followup = json["followUp"],
        deleted = json["deleted"],
        occurredAt = DateTime.parse(json["occurredAt"]),
        status = json["status"],
        synced = true,
        geometry =
            json["geometry"] != null ? jsonEncode(json["geometry"]) : null,
        notes = jsonEncode(json["notes"]) {
    id = D2EnrollmentRepository(db).getIdByUid(json["enrollment"]) ?? 0;

    trackedEntity.target =
        D2TrackedEntityRepository(db).getByUid(json["trackedEntity"]);
    orgUnit.target = D2OrgUnitRepository(db).getByUid(json["orgUnit"]);
    program.target = D2ProgramRepository(db).getByUid(json["program"]);
  }

  /// Constructor that creates an instance of [D2Enrollment] from form values [values].
  D2Enrollment.fromFormValues(Map<String, dynamic> values,
      {required D2ObjectBox db,
      required D2TrackedEntity trackedEntity,
      required D2Program program,
      required D2OrgUnit orgUnit})
      : uid = D2UID.generate(),
        updatedAt = DateTime.now(),
        createdAt = DateTime.now(),
        enrolledAt =
            DateTime.tryParse(values["enrolledAt"] ?? "") ?? DateTime.now(),
        followup = false,
        deleted = false,
        occurredAt =
            DateTime.tryParse(values["occurredAt"] ?? "") ?? DateTime.now(),
        status = values["status"] ?? 'ACTIVE',
        synced = false,
        notes = "[]" {
    this.trackedEntity.target = trackedEntity;
    this.orgUnit.target = orgUnit;
    this.program.target = program;

    if (values["geometry"] != null) {
      var geometryValue = values["geometry"];

      /// A form has geometry. This should be inserted as a serialized JSON.
      if (geometryValue is D2GeometryValue) {
        Map<String, dynamic> geometry = geometryValue.toGeoJson();
        String geometryString = jsonEncode(geometry);
        this.geometry = geometryString;
      }
    }
  }

  /// Whether the enrollment has been synced with the server.
  @override
  bool synced;

  /// Converts the enrollment object to a JSON map for serialization.
  @override
  Future<Map<String, dynamic>> toMap({D2ObjectBox? db}) async {
    if (db == null) {
      throw "ObjectBox instance is required";
    }

    Map<String, dynamic> payload = {
      "orgUnit": orgUnit.target?.uid,
      "program": program.target?.uid,
      "trackedEntity": trackedEntity.target?.uid,
      "enrollment": uid,
      "enrolledAt": enrolledAt.toIso8601String(),
      "deleted": deleted,
      "occurredAt": occurredAt.toIso8601String(),
      "status": status,
      "notes": jsonDecode(notes ?? "[]"),
    };

    if (geometry != null) {
      payload.addAll({"geometry": jsonDecode(geometry!)});
    }

    return payload;
  }

  /// Converts the enrollment object to form values.
  ///
  /// Returns a [Map<String, dynamic>]
  @override
  Map<String, dynamic> toFormValues() {
    Map<String, dynamic> data = {
      "occurredAt": occurredAt.toIso8601String(),
      "orgUnit": orgUnit.target!.uid,
      "enrolledAt": enrolledAt.toIso8601String()
    };

    if (geometry != null) {
      Map<String, dynamic> geometryObject = jsonDecode(geometry!);
      data.addAll({"geometry": D2GeometryValue.fromGeoJson(geometryObject)});
    }

    return data;
  }

  /// Updates the enrollment object from form input values.
  @override
  void updateFromFormValues(Map<String, dynamic> values,
      {required D2ObjectBox db, D2Program? program, D2OrgUnit? orgUnit}) {
    occurredAt = DateTime.tryParse(values["occurredAt"]) ?? occurredAt;
    enrolledAt = DateTime.tryParse(values["enrolledAt"]) ?? enrolledAt;
    if (orgUnit != null) {
      this.orgUnit.target = orgUnit;
    }
    trackedEntity.target!.updateFromFormValues(values,
        db: db, program: program, orgUnit: orgUnit);

    if (values["geometry"] != null) {
      var geometryValue = values["geometry"];

      /// A form has geometry. This should be inserted as a serialized JSON.
      if (geometryValue is D2GeometryValue) {
        Map<String, dynamic> geometry = geometryValue.toGeoJson();
        String geometryString = jsonEncode(geometry);
        this.geometry = geometryString;
      }
    }

    synced = false;
  }

  /// Saves the enrollment object to the database.
  @override
  void save(D2ObjectBox db) {
    id = D2EnrollmentRepository(db).saveEntity(this);
  }

  /// Deletes the enrollment object from the database.
  ///
  /// Returns a [bool] whether the enrollment object was deleted
  @override
  bool delete(D2ObjectBox db) {
    for (D2Event event in events) {
      event.delete(db);
    }
    for (D2Relationship relationship in relationships) {
      relationship.delete(db);
    }
    return D2EnrollmentRepository(db).deleteEntity(this);
  }

  /// Soft deletes the enrollment by marking it as deleted in the database.
  @override
  void softDelete(db) {
    deleted = true;
    for (D2Event event in events) {
      event.softDelete(db);
    }
    for (D2Relationship relationship in relationships) {
      relationship.softDelete(db);
    }
    save(db);
  }
}
