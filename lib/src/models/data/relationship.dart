import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/data/enrollment.dart';
import '../../repositories/data/event.dart';
import '../../repositories/data/relationship.dart';
import '../../repositories/data/tracked_entity.dart';
import '../../repositories/metadata/relationship_type.dart';
import '../metadata/relationship_type.dart';
import 'base.dart';
import 'enrollment.dart';
import 'event.dart';
import 'upload_base.dart';
import 'tracked_entity.dart';

@Entity()
class D2Relationship extends SyncDataSource implements SyncableData {
  @override
  int id = 0;
  @override
  DateTime createdAt;

  @override
  DateTime updatedAt;

  @override
  @Unique()
  String uid;

  final fromTrackedEntity = ToOne<D2TrackedEntity>();
  final fromEnrollment = ToOne<D2Enrollment>();
  final fromEvent = ToOne<D2Event>();

  final toTrackedEntity = ToOne<D2TrackedEntity>();
  final toEnrollment = ToOne<D2Enrollment>();
  final toEvent = ToOne<D2Event>();

  final relationshipType = ToOne<D2RelationshipType>();

  setConstraints(Map<String, dynamic> constraint,
      {required String type, required D2ObjectBox db}) {
    switch (type) {
      case "from":
        if (constraint["trackedEntity"] != null) {
          String trackedEntity = constraint["trackedEntity"]["trackedEntity"];
          fromTrackedEntity.target =
              D2TrackedEntityRepository(db).getByUid(trackedEntity);
          return;
        }
        if (constraint["enrollment"] != null) {
          String enrollment = constraint["enrollment"]["enrollment"];
          fromEnrollment.target =
              D2EnrollmentRepository(db).getByUid(enrollment);
          return;
        }
        if (constraint["event"] != null) {
          String event = constraint["event"]["event"];
          fromEvent.target = D2EventRepository(db).getByUid(event);
          return;
        }
      case "to":
        if (constraint["trackedEntity"] != null) {
          String trackedEntity = constraint["trackedEntity"]["trackedEntity"];
          toTrackedEntity.target =
              D2TrackedEntityRepository(db).getByUid(trackedEntity);
          return;
        }
        if (constraint["enrollment"] != null) {
          String enrollment = constraint["enrollment"]["enrollment"];
          toEnrollment.target = D2EnrollmentRepository(db).getByUid(enrollment);
          return;
        }
        if (constraint["event"] != null) {
          String event = constraint["event"]["event"];
          toEvent.target = D2EventRepository(db).getByUid(event);
          return;
        }
    }
  }

  Map<String, dynamic>? getConstraints(String type) {
    if (type case "from") {
      if (fromTrackedEntity.target != null) {
        return {
          "trackedEntity": {"trackedEntity": fromTrackedEntity.target!.uid}
        };
      }
      if (fromEnrollment.target != null) {
        return {
          "enrollment": {"enrollment": fromEnrollment.target!.uid}
        };
      }
      if (fromEvent.target != null) {
        return {
          "event": {"event": fromEvent.target!.uid}
        };
      }
    } else if (type case "to") {
      if (toTrackedEntity.target != null) {
        return {
          "trackedEntity": {"trackedEntity": toTrackedEntity.target!.uid}
        };
      }
      if (toEnrollment.target != null) {
        return {
          "enrollment": {"enrollment": toEnrollment.target!.uid}
        };
      }
      if (toEvent.target != null) {
        return {
          "event": {"event": toEvent.target!.uid}
        };
      }
    } else {
      throw "Something is not right. ";
    }
    return null;
  }

  D2Relationship(
      this.id, this.createdAt, this.updatedAt, this.uid, this.synced);

  D2Relationship.fromMap(D2ObjectBox db, Map json)
      : createdAt = DateTime.parse(json["createdAt"]),
        updatedAt = DateTime.parse(json["updatedAt"]),
        uid = json["relationship"],
        synced = true {
    id = D2RelationshipRepository(db).getIdByUid(json["relationship"]) ?? 0;
    relationshipType.target =
        D2RelationshipTypeRepository(db).getByUid(json["relationshipType"]);
    setConstraints(json["from"], type: "from", db: db);
    setConstraints(json["to"], type: "to", db: db);
  }

  @override
  bool synced;

  @override
  Future<Map<String, dynamic>> toMap({D2ObjectBox? db}) async {
    if (db == null) {
      throw "ObjectBox instance is required";
    }

    Map<String, dynamic> payload = {
      "relationship": uid,
      "relationshipType": relationshipType.target!.uid,
      "from": getConstraints("from"),
      "to": getConstraints("to")
    };

    return payload;
  }
}
