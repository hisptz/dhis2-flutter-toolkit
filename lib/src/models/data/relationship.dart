import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:dhis2_flutter_toolkit/src/models/data/base_deletable.dart';
import 'package:dhis2_flutter_toolkit/src/utils/uid.dart';
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
import 'tracked_entity.dart';
import 'upload_base.dart';

@Entity()

/// This class represents a relationship between entities in the DHIS2 system.
///
/// This class extends [SyncDataSource] and implements [SyncableData] and [D2BaseDeletable].
class D2Relationship extends SyncDataSource
    implements SyncableData, D2BaseDeletable {
  @override
  int id = 0;

  /// The creation date of the relationship.
  @override
  DateTime createdAt;

  /// The last update date of the relationship.
  @override
  DateTime updatedAt;

  /// The unique identifier string for the relationship.
  @override
  @Unique()
  String uid;

  /// Whether the relationship is deleted.
  bool deleted;

  /// The tracked entity from which the relationship originates.
  final fromTrackedEntity = ToOne<D2TrackedEntity>();

  /// The enrollment from which the relationship originates.
  final fromEnrollment = ToOne<D2Enrollment>();

  /// The event from which the relationship originates.
  final fromEvent = ToOne<D2Event>();

  /// The tracked entity to which the relationship points.
  final toTrackedEntity = ToOne<D2TrackedEntity>();

  /// The enrollment to which the relationship points.
  final toEnrollment = ToOne<D2Enrollment>();

  /// The event to which the relationship points.
  final toEvent = ToOne<D2Event>();

  /// The type of relationship.
  final relationshipType = ToOne<D2RelationshipType>();

  /// Sets the constraints for the relationship based on the provided [constraint] map.
  ///
  /// - [type] specifies whether the constraint is "from" or "to".
  /// - [db] is the database instance.
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

  /// Retrieves the constraints for the relationship based on the [type].
  ///
  /// - [type] specifies whether to retrieve "from" or "to" constraints.
  /// - Returns a map of the constraints, or null if not set.
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

  /// Constructs a new [D2Relationship] instance.
  D2Relationship(this.id, this.createdAt, this.updatedAt, this.uid, this.synced,
      this.deleted);

  /// Constructs a new [D2Relationship] instance from a map.
  ///
  /// - [db] is the database instance.
  /// - [json] is the map containing the relationship data.
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

  /// Whether the relationship is synced.
  @override
  bool synced;

  /// Converts the [D2Relationship] instance to a map.
  ///
  /// - [db] is the database instance.
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

  /// Constructs a new [D2Relationship] instance with the specified constraints.
  ///
  /// - [from] is the source entity.
  /// - [to] is the target entity.
  /// - [type] is the relationship type.
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

  /// Marks the relationship as deleted without removing it from the database.
  ///
  /// - [db] is the database instance.
  @override
  void softDelete(db) {
    deleted = true;
    D2RelationshipRepository(db).saveEntity(this);
  }

  /// Deletes the relationship from the database.
  ///
  /// - [db] is the database instance.
  ///
  /// Returns [bool] Whether the deletion was successful.
  @override
  bool delete(D2ObjectBox db) {
    return D2RelationshipRepository(db).deleteEntity(this);
  }
}
