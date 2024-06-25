import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import '../../repositories/metadata/tracked_entity_attribute.dart';
import '../metadata/org_unit.dart';
import '../metadata/tracked_entity_attribute.dart';

@Entity()

/// This class represents a reserved value for a tracked entity attribute.
///
/// The [D2ReservedValue] class holds information about a reserved value
/// including its association with a [D2TrackedEntityAttribute] and [D2OrgUnit].
class D2ReservedValue {
  /// The unique identifier of the reserved value.
  int id = 0;

  /// The tracked entity attribute associated with this reserved value.
  final trackedEntityAttribute = ToOne<D2TrackedEntityAttribute>();

  /// The organization unit associated with this reserved value.
  final orgUnit = ToOne<D2OrgUnit>();

  /// The value of the reserved value.
  String value;

  /// The owner of the reserved value.
  String owner;

  /// Whether the reserved value is assigned.
  bool assigned;

  /// The date when the reserved value was created.
  DateTime createdOn;

  /// The date when the reserved value expires.
  DateTime expiresOn;

  /// Constructs a [D2ReservedValue] instance.
  ///
  /// - [value] is the reserved value.
  /// - [assigned] indicates whether the value is assigned.
  /// - [id] is the unique identifier.
  /// - [createdOn] is the creation date.
  /// - [expiresOn] is the expiration date.
  /// - [owner] is the owner of the reserved value.
  D2ReservedValue(this.value, this.assigned, this.id, this.createdOn,
      this.expiresOn, this.owner);

  /// Constructs a [D2ReservedValue] instance from a map.
  ///
  /// - [db] is the instance of [D2ObjectBox] used for database operations.
  /// - [json] is the map containing the reserved value data.
  /// - [orgUnit] is the optional organization unit associated with the value.
  D2ReservedValue.fromMap(D2ObjectBox db, Map json, {D2OrgUnit? orgUnit})
      : value = json["value"],
        createdOn = DateTime.parse(json["created"]),
        expiresOn = DateTime.parse(json["expiryDate"]),
        assigned = false,
        owner = json["ownerObject"] {
    this.orgUnit.target = orgUnit;
    if (owner == "TRACKEDENTITYATTRIBUTE") {
      trackedEntityAttribute.target =
          D2TrackedEntityAttributeRepository(db).getByUid(json["ownerUid"]);
    }
  }

  /// Sets the reserved value as assigned.
  void setAssigned() {
    assigned = true;
  }
}
