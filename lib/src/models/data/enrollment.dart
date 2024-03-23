import 'dart:convert';

import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import '../../repositories/data/enrollment.dart';
import '../../repositories/data/tracked_entity.dart';
import '../../repositories/metadata/org_unit.dart';
import '../../repositories/metadata/program.dart';
import '../metadata/org_unit.dart';
import '../metadata/program.dart';
import 'base.dart';
import 'base_editable.dart';
import 'event.dart';
import 'tracked_entity.dart';
import 'upload_base.dart';

@Entity()
class D2Enrollment extends SyncDataSource
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
  DateTime enrolledAt;
  bool deleted;
  bool followup;
  DateTime occurredAt;
  String status;
  String? notes;

  @Backlink("enrollment")
  final events = ToMany<D2Event>();

  //Disabled for now
  // @Backlink("enrollment")
  // final relationships = ToMany<D2Relationship>();

  final trackedEntity = ToOne<D2TrackedEntity>();

  final orgUnit = ToOne<D2OrgUnit>();

  final program = ToOne<D2Program>();

  get orgUnitName {
    return orgUnit.target?.name;
  }

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
      this.synced);

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
        notes = jsonEncode(json["notes"]) {
    id = D2EnrollmentRepository(db).getIdByUid(json["enrollment"]) ?? 0;

    trackedEntity.target =
        D2TrackedEntityRepository(db).getByUid(json["trackedEntity"]);
    orgUnit.target = D2OrgUnitRepository(db).getByUid(json["orgUnit"]);
    program.target = D2ProgramRepository(db).getByUid(json["program"]);
  }

  @override
  bool synced;

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

    return payload;
  }

  @override
  Map<String, dynamic> toFormValues() {
    Map<String, dynamic> data = {
      "occurredAt": occurredAt.toIso8601String(),
      "orgUnit": orgUnit.target!.uid
    };

    List<String> programAttributeIds = program
            .target?.programTrackedEntityAttributes
            .map((pAttribute) => pAttribute.trackedEntityAttribute.target!.uid)
            .toList() ??
        [];
    //Get attributes that are only associated to this enrollment. Check is done by the program
    trackedEntity.target?.attributes.forEach((element) {
      if (programAttributeIds.contains(element.uid)) {
        data.addAll(element.toFormValues());
      }
    });

    return data;
  }

  @override
  void updateFromFormValues(Map<String, dynamic> values,
      {required D2ObjectBox db}) {
    occurredAt = DateTime.tryParse(values["occurredAt"]) ?? occurredAt;
    orgUnit.target =
        D2OrgUnitRepository(db).getByUid(values["orgUnit"]) ?? orgUnit.target;
    trackedEntity.target!.updateFromFormValues(values, db: db);
    synced = false;
  }
}
