import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/models/data/base_editable.dart';
import 'package:objectbox/objectbox.dart';

import '../../utils/uid.dart';
import 'base.dart';
import 'upload_base.dart';

@Entity()
class D2TrackedEntity extends SyncDataSource
    implements SyncableData, D2BaseEditable {
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

  @Backlink("trackedEntity")
  final enrollments = ToMany<D2Enrollment>();

  final enrollmentsForQuery = ToMany<D2Enrollment>();

  //Disabled for now
  // final relationships = ToMany<D2Relationship>();

  final orgUnit = ToOne<D2OrgUnit>();

  @Backlink("trackedEntity")
  final attributes = ToMany<D2TrackedEntityAttributeValue>();

  final trackedEntityType = ToOne<D2TrackedEntityType>();

  @Backlink("trackedEntity")
  final events = ToMany<D2Event>();

  D2TrackedEntity(this.uid, this.createdAt, this.updatedAt, this.deleted,
      this.potentialDuplicate, this.inactive, this.synced, this.geometry);

  D2TrackedEntity.fromMap(D2ObjectBox db, Map json)
      : uid = json["trackedEntity"],
        createdAt = DateTime.parse(json["createdAt"]),
        updatedAt = DateTime.parse(json["updatedAt"]),
        deleted = json["deleted"],
        synced = true,
        potentialDuplicate = json["potentialDuplicate"],
        geometry =
            json["geometry"] != null ? jsonEncode(json["geometry"]) : null,
        inactive = json["inactive"] {
    id = D2TrackedEntityRepository(db).getIdByUid(json["trackedEntity"]) ?? 0;
    orgUnit.target = D2OrgUnitRepository(db).getByUid(json["orgUnit"]);
    trackedEntityType.target =
        D2TrackedEntityTypeRepository(db).getByUid(json["trackedEntityType"]);
  }

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
        uid = D2UID.generate() {
    this.orgUnit.target = orgUnit;
    trackedEntityType.target = program.trackedEntityType.target;

    List<D2TrackedEntityAttribute> trackedEntityAttributes = program
        .programTrackedEntityAttributes
        .map((pAttribute) => pAttribute.trackedEntityAttribute.target!)
        .toList();

    List<D2TrackedEntityAttributeValue?> attributeValues =
        trackedEntityAttributes.map((teiAttribute) {
      String? value = values[teiAttribute.uid];
      return D2TrackedEntityAttributeValue.fromFormValues(value,
          db: db, trackedEntity: this, trackedEntityAttribute: teiAttribute);
    }).toList();

    List<D2TrackedEntityAttributeValue> attributeWithValues = attributeValues
        .where((element) => element != null)
        .toList()
        .cast<D2TrackedEntityAttributeValue>();

    attributes.addAll([...attributeWithValues]);
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
      "trackedEntity": uid,
      "trackedEntityType": trackedEntityType.target!.uid,
      "attributes": attributesPayload,
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
    return {
      "orgUnit": orgUnit.target!.uid,
      "attributes":
          attributes.map((attribute) => attribute.toFormValues()).toList()
    };
  }

  @override
  void updateFromFormValues(Map<String, dynamic> values,
      {required D2ObjectBox db, D2OrgUnit? orgUnit}) {
    for (D2TrackedEntityAttributeValue attributeValue in attributes) {
      attributeValue.updateFromFormValues(values, db: db);
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
}
