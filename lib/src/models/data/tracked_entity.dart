import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/models/data/base_deletable.dart';
import 'package:dhis2_flutter_toolkit/src/models/data/base_editable.dart';
import 'package:objectbox/objectbox.dart';

import 'base.dart';
import 'upload_base.dart';

@Entity()
class D2TrackedEntity extends SyncDataSource
    implements SyncableData, D2BaseEditable, D2BaseDeletable {
  @override
  int id = 0;
  @override
  DateTime createdAt;

  @override
  DateTime updatedAt;

  @override
  @Unique()
  String uid;
  bool potentialDuplicate;
  bool deleted;
  bool inactive;

  String? geometry;
  String? createdBy;

  @Backlink("trackedEntity")
  final enrollments = ToMany<D2Enrollment>();
  final enrollmentsForQuery = ToMany<D2Enrollment>();

  @Backlink("trackedEntity")
  final programOwners = ToMany<D2ProgramOwner>();

  @Backlink("fromTrackedEntity")
  final relationships = ToMany<D2Relationship>();
  final relationshipsForQuery = ToMany<D2Relationship>();

  @Backlink("toTrackedEntity")
  final toRelationships = ToMany<D2Relationship>();

  final orgUnit = ToOne<D2OrgUnit>();

  @Backlink("trackedEntity")
  final attributes = ToMany<D2TrackedEntityAttributeValue>();
  final attributesForQuery = ToMany<D2TrackedEntityAttributeValue>();

  final trackedEntityType = ToOne<D2TrackedEntityType>();

  @Backlink("trackedEntity")
  final events = ToMany<D2Event>();

  D2TrackedEntity(
      this.uid,
      this.createdAt,
      this.updatedAt,
      this.deleted,
      this.potentialDuplicate,
      this.inactive,
      this.synced,
      this.geometry,
      this.createdBy);

  D2TrackedEntity.fromMap(D2ObjectBox db, Map json)
      : uid = json["trackedEntity"],
        createdAt = DateTime.parse(json["createdAt"]),
        updatedAt = DateTime.parse(json["updatedAt"]),
        deleted = json["deleted"] ?? false,
        synced = true,
        createdBy = json["createdBy"]?["username"],
        potentialDuplicate = json["potentialDuplicate"] ?? false,
        geometry =
            json["geometry"] != null ? jsonEncode(json["geometry"]) : null,
        inactive = json["inactive"] ?? false {
    id = D2TrackedEntityRepository(db).getIdByUid(json["trackedEntity"]) ?? 0;
    orgUnit.target = D2OrgUnitRepository(db).getByUid(json["orgUnit"]);
    trackedEntityType.target =
        D2TrackedEntityTypeRepository(db).getByUid(json["trackedEntityType"]);
    //Get the trackedEntityAttributeValues
    List<D2TrackedEntityAttributeValue> attributeValues = json["attributes"]
        ?.map<D2TrackedEntityAttributeValue>((attributeValue) =>
            D2TrackedEntityAttributeValue.fromMap(
                db, attributeValue, json["trackedEntity"]))
        .toList();
    attributes.addAll(attributeValues);

    //this is a new implementation to support Tracker ownership. It requires the instance from data to be correctly mapped. So we do have to remove program owners that no longer apply
    List<D2ProgramOwner> programOwnerValues = json["programOwners"]
        ?.map<D2ProgramOwner>(
            (programOwner) => D2ProgramOwner.fromMap(db, programOwner))
        .toList();

    programOwners.addAll(programOwnerValues.toSet().toList());
  }

  //TODO: This needs to be modified to separate registration using trackedEntityType or enrollment with a program.
  D2TrackedEntity.fromFormValues(Map<String, dynamic> values,
      {required D2ObjectBox db,
      required D2Program program,
      required D2OrgUnit orgUnit,
      bool enroll = true})
      : createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        potentialDuplicate = false,
        deleted = false,
        synced = false,
        inactive = false,
        createdBy = D2UserRepository(db).get()?.username ?? '',
        uid = D2UID.generate() {
    this.orgUnit.target = orgUnit;
    trackedEntityType.target = program.trackedEntityType.target;
    List<D2TrackedEntityAttribute> trackedEntityAttributes = program
        .programTrackedEntityAttributes
        .map((pAttribute) => pAttribute.trackedEntityAttribute.target!)
        .toSet()
        .toList();

    List<D2TrackedEntityAttributeValue?> attributeValues =
        trackedEntityAttributes
            .map((teiAttribute) {
              String? value = values[teiAttribute.uid];
              return D2TrackedEntityAttributeValue.fromFormValues(value,
                  db: db,
                  trackedEntity: this,
                  trackedEntityAttribute: teiAttribute);
            })
            .toSet()
            .toList();

    List<D2TrackedEntityAttributeValue> attributeWithValues = attributeValues
        .where((element) => element != null)
        .toList()
        .cast<D2TrackedEntityAttributeValue>();
    attributes.addAll([...attributeWithValues]);

    if (values["geometry"] != null) {
      var geometryValue = values["geometry"];

      ///A form has geometry. This should be inserted as a serialized JSON
      if (geometryValue is D2GeometryValue) {
        Map<String, dynamic> geometry = geometryValue.toGeoJson();
        String geometryString = jsonEncode(geometry);
        this.geometry = geometryString;
      }
    }

    if (enroll) {
      D2Enrollment enrollment = D2Enrollment.fromFormValues(values,
          db: db, trackedEntity: this, program: program, orgUnit: orgUnit);
      enrollments.add(enrollment);
    }
  }

  @override
  bool synced;

  @override
  Future<Map<String, dynamic>> toMap({D2ObjectBox? db}) async {
    if (db == null) {
      throw "ObjectBox instance is required";
    }

    List<Map<String, dynamic>> attributesPayload = await Future.wait(attributes
        .map<Future<Map<String, dynamic>>>((e) => e.toMap(db: db))
        .toList());

    Map<String, dynamic> payload = {
      "orgUnit": orgUnit.target!.uid,
      "updatedAt": updatedAt.toIso8601String(),
      "createdAt": createdAt.toIso8601String(),
      "trackedEntity": uid,
      "deleted": deleted,
      "inactive": inactive,
      "potentialDuplicate": potentialDuplicate,
      "trackedEntityType": trackedEntityType.target!.uid,
      "attributes": attributesPayload,
      "programOwners": programOwners.map((e) => e.toMap(db: db)).toList(),
    };
    if (geometry != null) {
      payload.addAll({"geometry": jsonDecode(geometry!)});
    }

    return payload;
  }

  ///Filters out the trackedEntity attributes for a specific program. This is useful when requiring data for a specific enrollment
  List<D2TrackedEntityAttributeValue> getAttributesByProgram(
      D2Program program) {
    List<String> programAttributes = program.programTrackedEntityAttributes
        .map((pAttribute) => pAttribute.trackedEntityAttribute.target!.uid)
        .toList();

    return attributes
        .where((element) => programAttributes
            .contains(element.trackedEntityAttribute.target!.uid))
        .toList();
  }

  @override
  Map<String, dynamic> toFormValues() {
    Map<String, dynamic> data = {
      "orgUnit": orgUnit.target!.uid,
      "attributes":
          attributes.map((attribute) => attribute.toFormValues()).toList()
    };
    if (geometry != null) {
      Map<String, dynamic> geometryObject = jsonDecode(geometry!);
      data.addAll({"geometry": D2GeometryValue.fromGeoJson(geometryObject)});
    }

    return data;
  }

  void updateAttributes(
      {required D2Program program,
      required Map<String, dynamic> values,
      required D2ObjectBox db}) {
    for (D2ProgramTrackedEntityAttribute attribute
        in program.programTrackedEntityAttributes) {
      String attributeId = attribute.trackedEntityAttribute.target!.uid;
      D2TrackedEntityAttributeValue? attributeValue =
          attributes.firstWhereOrNull((element) =>
              element.trackedEntityAttribute.target?.uid == attributeId);
      if (attributeValue != null) {
        attributeValue.updateFromFormValues(values, db: db);
        continue;
      }
      D2TrackedEntityAttributeValue newAttributeValue =
          D2TrackedEntityAttributeValue.fromFormValues(values[attributeId],
              db: db,
              trackedEntity: this,
              trackedEntityAttribute: attribute.trackedEntityAttribute.target!);

      attributes.add(newAttributeValue);
    }
  }

  @override
  void updateFromFormValues(Map<String, dynamic> values,
      {required D2ObjectBox db, D2Program? program, D2OrgUnit? orgUnit}) {
    updatedAt = DateTime.now();
    if (program == null) {
      throw "Program is required to edit a tracked entity";
    }

    updateAttributes(program: program, values: values, db: db);

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
      id = D2TrackedEntityRepository(db).saveEntity(this);
    } else {
      D2TrackedEntityRepository(db).saveEntity(this);
      for (D2TrackedEntityAttributeValue attribute in attributes) {
        attribute.save(db);
      }
    }
  }

  D2Enrollment? getActiveEnrollmentByProgram(D2Program program) {
    return enrollments.firstWhereOrNull(
        (enrollment) => enrollment.program.target?.id == program.id);
  }

  @override
  void softDelete(db) {
    deleted = true;
    for (D2Relationship relationship in relationships) {
      relationship.softDelete(db);
    }
    //Delete enrollments
    for (D2Enrollment enrollment in enrollments) {
      enrollment.softDelete(db);
    }
    save(db);
  }

  @override
  bool delete(D2ObjectBox db) {
    D2TrackedEntityAttributeValueRepository(db).deleteEntities(attributes);

    for (D2Relationship relationship in relationships) {
      relationship.delete(db);
    }
    //Delete enrollments
    for (D2Enrollment enrollment in enrollments) {
      enrollment.delete(db);
    }

    return D2TrackedEntityRepository(db).deleteEntity(this);
  }

  Future<void> upload(
      {required D2ClientService client, required D2ObjectBox db}) async {
    return D2TrackedEntityRepository(db).setupUpload(client).uploadOne(this);
  }
}
