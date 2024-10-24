import 'package:dhis2_flutter_toolkit/src/models/data/base_deletable.dart';
import 'package:objectbox/objectbox.dart';

import '../../../dhis2_flutter_toolkit.dart';
import 'base.dart';
import 'upload_base.dart';

@Entity()
class D2Relationship extends SyncDataSource
    implements SyncableData, D2BaseDeletable {
  @override
  int id = 0;
  @override
  DateTime createdAt;

  @override
  DateTime updatedAt;

  @override
  @Unique()
  String uid;

  bool deleted;

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

  D2Relationship(this.id, this.createdAt, this.updatedAt, this.uid, this.synced,
      this.deleted);

  D2Relationship.fromMap(D2ObjectBox db, Map json)
      : createdAt = DateTime.parse(json["createdAt"]),
        updatedAt = DateTime.parse(json["updatedAt"]),
        uid = json["relationship"],
        deleted = false,
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

  D2Relationship.fromConstraints(
      {required D2DataResource from,
      required D2DataResource to,
      required D2RelationshipType type})
      : uid = D2UID.generate(),
        synced = false,
        deleted = false,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now() {
    relationshipType.target = type;

    if (from is D2TrackedEntity) {
      fromTrackedEntity.target = from;
    }
    if (from is D2Enrollment) {
      fromEnrollment.target = from;
    }
    if (from is D2Event) {
      fromEvent.target = from;
    }

    if (to is D2TrackedEntity) {
      toTrackedEntity.target = to;
    }
    if (to is D2Enrollment) {
      toEnrollment.target = to;
    }
    if (to is D2Event) {
      toEvent.target = to;
    }
  }

  @override
  void softDelete(db) {
    deleted = true;
    D2RelationshipRepository(db).saveEntity(this);
  }

  void save(D2ObjectBox db) {
    if (id == 0) {
      id = D2RelationshipRepository(db).saveEntity(this);
    } else {
      D2RelationshipRepository(db).saveEntity(this);
    }
  }

  @override
  bool delete(D2ObjectBox db) {
    return D2RelationshipRepository(db).deleteEntity(this);
  }

  Future<void> upload(
      {required D2ClientService client, required D2ObjectBox db}) async {
    return D2RelationshipRepository(db).setupUpload(client).uploadOne(this);
  }
}
