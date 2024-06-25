import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import '../../repositories/metadata/program.dart';
import '../../repositories/metadata/program_stage.dart';
import '../../repositories/metadata/relationship_type.dart';
import '../../repositories/metadata/tracked_entity_type.dart';
import 'base.dart';
import 'program.dart';
import 'program_stage.dart';
import 'tracked_entity_type.dart';

@Entity()

/// This class represents a relationship type in the DHIS2 system.
///
/// This class extends [D2MetaResource] and includes various properties
/// and methods for handling relationship types.
class D2RelationshipType extends D2MetaResource {
  @override
  int id = 0;

  /// Name of the relationship type.
  String name;

  /// Date when the relationship type was created.
  DateTime created;

  /// Date when the relationship type was last updated.
  DateTime lastUpdated;

  /// Unique identifier string for the relationship type.
  @Unique()
  @override
  String uid;

  /// Display name for the relationship type.
  String? displayName;

  /// Name representing the relationship from the "from" entity to the "to" entity.
  String? fromToName;

  /// Name representing the relationship from the "to" entity to the "from" entity.
  String? toFromName;

  /// Display name for the "from" to "to" relationship.
  String? displayFromToName;

  /// Display name for the "to" to "from" relationship.
  String? displayToFromName;

  /// Indicates if the relationship type is a referral.
  bool? referral;

  /// Entity type for the "from" side of the relationship.
  String fromRelationshipEntity;

  /// Entity type for the "to" side of the relationship.
  String toRelationshipEntity;

  /// Relationship to the [D2TrackedEntityType] for the "from" side.
  final fromTrackedEntityType = ToOne<D2TrackedEntityType>();

  /// Relationship to the [D2Program] for the "from" side.
  final fromProgram = ToOne<D2Program>();

  /// Relationship to the [D2ProgramStage] for the "from" side.
  final fromProgramStage = ToOne<D2ProgramStage>();

  /// Relationship to the [D2TrackedEntityType] for the "to" side.
  final toTrackedEntityType = ToOne<D2TrackedEntityType>();

  /// Relationship to the [D2Program] for the "to" side.
  final toProgram = ToOne<D2Program>();

  /// Relationship to the [D2ProgramStage] for the "to" side.
  final toProgramStage = ToOne<D2ProgramStage>();

  /// Populates the "from" side constraints from a given map.
  ///
  /// - [db] is the instance of [D2ObjectBox].
  /// - [constraints] is a map containing the constraints for the "from" side.
  void getFromConstraints(D2ObjectBox db, Map constraints) {
    if (constraints["program"] != null) {
      fromProgram.target =
          D2ProgramRepository(db).getByUid(constraints["program"]["id"]);
    }
    if (constraints["programStage"] != null) {
      fromProgramStage.target = D2ProgramStageRepository(db)
          .getByUid(constraints["programStage"]["id"]);
    }
    if (constraints["trackedEntityType"] != null) {
      fromTrackedEntityType.target = D2TrackedEntityTypeRepository(db)
          .getByUid(constraints["trackedEntityType"]["id"]);
    }
  }

  /// Populates the "to" side constraints from a given map.
  ///
  /// - [db] is the instance of [D2ObjectBox].
  /// - [constraints] is a map containing the constraints for the "to" side.
  void getToConstraints(D2ObjectBox db, Map constraints) {
    if (constraints["program"] != null) {
      toProgram.target =
          D2ProgramRepository(db).getByUid(constraints["program"]["id"]);
    }
    if (constraints["programStage"] != null) {
      toProgramStage.target = D2ProgramStageRepository(db)
          .getByUid(constraints["programStage"]["id"]);
    }
    if (constraints["trackedEntityType"] != null) {
      toTrackedEntityType.target = D2TrackedEntityTypeRepository(db)
          .getByUid(constraints["trackedEntityType"]["id"]);
    }
  }

  /// Constructs a [D2RelationshipType] instance with the given properties.
  D2RelationshipType(
      this.id,
      this.name,
      this.displayName,
      this.fromToName,
      this.toFromName,
      this.displayFromToName,
      this.displayToFromName,
      this.referral,
      this.fromRelationshipEntity,
      this.toRelationshipEntity,
      this.lastUpdated,
      this.created,
      this.uid);

  /// Constructs a [D2RelationshipType] instance from a map.
  ///
  /// - [db] is the instance of [D2ObjectBox].
  /// - [json] is the map containing the relationship type data.
  D2RelationshipType.fromMap(D2ObjectBox db, Map json)
      : name = json["name"],
        uid = json["id"],
        created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"]),
        displayName = json["displayName"],
        displayFromToName = json["displayFromToName"],
        displayToFromName = json["displayToFromName"],
        fromToName = json["fromToName"],
        toFromName = json["toFromName"],
        referral = json["referral"],
        fromRelationshipEntity = json["fromConstraint"]["relationshipEntity"],
        toRelationshipEntity = json["toConstraint"]["relationshipEntity"] {
    id = D2RelationshipTypeRepository(db).getIdByUid(json["id"]) ?? 0;
    Map fromConstraint = json["fromConstraint"];
    Map toConstraint = json["toConstraint"];

    getFromConstraints(db, fromConstraint);
    getToConstraints(db, toConstraint);
  }
}
