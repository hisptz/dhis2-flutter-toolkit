import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/tracked_entity_attribute.dart';
import 'base.dart';
import 'tracked_entity_attribute.dart';
import 'tracked_entity_type.dart';

@Entity()

/// This class represents an attribute of a tracked entity type in the DHIS2 system.
class D2TrackedEntityTypeAttribute extends D2MetaResource {
  @override
  int id = 0;

  /// The creation date of the tracked entity type attribute.
  @override
  DateTime created;

  /// The last updated date of the tracked entity type attribute.
  @override
  DateTime lastUpdated;

  /// The unique UID of the tracked entity type attribute.
  @override
  String uid;

  /// The associated tracked entity type.
  final trackedEntityType = ToOne<D2TrackedEntityType>();

  /// The associated tracked entity attribute.
  final trackedEntityAttribute = ToOne<D2TrackedEntityAttribute>();

  /// The value type of the tracked entity type attribute.
  String valueType;

  /// The display name of the tracked entity type attribute.
  @override
  String? displayName;

  /// The display short name of the tracked entity type attribute.
  String displayShortName;

  /// Indicates whether the tracked entity type attribute is mandatory.
  bool mandatory;

  /// Constructs a new [D2TrackedEntityTypeAttribute].
  ///
  /// - [id] The unique identifier for the tracked entity type attribute.
  /// - [displayName] The display name of the tracked entity type attribute.
  /// - [created] The creation date of the tracked entity type attribute.
  /// - [lastUpdated] The last updated date of the tracked entity type attribute.
  /// - [uid] The unique UID of the tracked entity type attribute.
  /// - [valueType] The value type of the tracked entity type attribute.
  /// - [displayShortName] The display short name of the tracked entity type attribute.
  /// - [mandatory] Indicates whether the tracked entity type attribute is mandatory.
  D2TrackedEntityTypeAttribute(
      this.id,
      this.displayName,
      this.created,
      this.lastUpdated,
      this.uid,
      this.valueType,
      this.displayShortName,
      this.mandatory);

  /// Constructs a new [D2TrackedEntityTypeAttribute] from a JSON object.
  ///
  /// - [db] The database instance.
  /// - [json] The JSON object containing tracked entity type attribute data.
  D2TrackedEntityTypeAttribute.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"]),
        uid = json["id"],
        valueType = json["valueType"],
        displayName = json["displayName"],
        displayShortName = json["displayShortName"],
        mandatory = json["mandatory"] {
    id = D2TrackedEntityAttributeRepository(db).getIdByUid(json["id"]) ?? 0;
  }
}
