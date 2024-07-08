import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/tracked_entity_type.dart';
import 'base.dart';
import 'tracked_entity_type_attribute.dart';

@Entity()

/// This class represents a tracked entity type in the DHIS2 system.
class D2TrackedEntityType extends D2MetaResource {
  @override
  int id = 0;

  /// The creation date of the tracked entity type.
  @override
  DateTime created;

  /// The last updated date of the tracked entity type.
  @override
  DateTime lastUpdated;

  /// The unique UID of the tracked entity type.
  @override
  @Unique()
  String uid;

  /// The name of the tracked entity type.
  String name;

  /// The description of the tracked entity type.
  String? description;

  /// A collection of attributes associated with the tracked entity type.
  final trackedEntityTypeAttributes = ToMany<D2TrackedEntityTypeAttribute>();

  /// Constructs a new [D2TrackedEntityType].
  ///
  /// - [id] :The unique identifier for the tracked entity type.
  /// - [displayName] :The display name of the tracked entity type.
  /// - [created] :The creation date of the tracked entity type.
  /// - [lastUpdated] :The last updated date of the tracked entity type.
  /// - [uid] :The unique UID of the tracked entity type.
  /// - [name] :The name of the tracked entity type.
  /// - [description] :The description of the tracked entity type.
  D2TrackedEntityType(this.id, this.displayName, this.created, this.lastUpdated,
      this.uid, this.name, this.description);

  /// Constructs a new [D2TrackedEntityType] from a JSON object.
  ///
  /// - [db] The database instance.
  /// - [json] The JSON object containing tracked entity type data.
  D2TrackedEntityType.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"]),
        uid = json["id"],
        name = json["name"],
        description = json["description"],
        displayName = json["displayName"] {
    id = D2TrackedEntityTypeRepository(db).getIdByUid(json["id"]) ?? 0;
  }

  /// The display name of the tracked entity type.
  @override
  String? displayName;
}
