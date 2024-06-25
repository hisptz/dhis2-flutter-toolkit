import 'package:collection/collection.dart';
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/models/data/base_editable.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/data/entry.dart';
import '../../repositories/metadata/entry.dart';
import '../metadata/entry.dart';
import 'upload_base.dart';

@Entity()

/// This class represents a tracked entity attribute value in the DHIS2 system.
///
/// This class holds the value of a tracked entity attribute for a specific tracked entity.
class D2TrackedEntityAttributeValue extends D2DataResource
    implements SyncableData, D2BaseEditable {
  @override
  int id = 0;

  /// The date and time when the attribute value was created.
  @override
  DateTime createdAt;

  /// Unique identifier for the attribute value.
  @Unique()
  String uid;

  /// The date and time when the attribute value was last updated.
  @override
  DateTime updatedAt;

  /// The value of the tracked entity attribute.
  String? value;

  /// Reference to the tracked entity attribute.
  final trackedEntityAttribute = ToOne<D2TrackedEntityAttribute>();

  /// Reference to the tracked entity.
  final trackedEntity = ToOne<D2TrackedEntity>();

  /// Constructs a new [D2TrackedEntityAttributeValue] with the provided parameters.
  D2TrackedEntityAttributeValue(
      this.uid, this.createdAt, this.updatedAt, this.value, this.synced);

  /// Constructs a new [D2TrackedEntityAttributeValue] from a map.
  ///
  /// - [db] The database instance.
  /// - [json] The JSON object containing attribute value data.
  /// - [trackedEntityId] The unique identifier of the tracked entity.
  D2TrackedEntityAttributeValue.fromMap(
      D2ObjectBox db, Map json, String trackedEntityId)
      : createdAt = DateTime.parse(json["createdAt"]),
        updatedAt = DateTime.parse(json["updatedAt"]),
        uid = "$trackedEntityId-${json["attribute"]}",
        synced = true,
        value = json["value"] {
    String uid = "$trackedEntityId-${json["attribute"]}";
    id = D2TrackedEntityAttributeValueRepository(db).getIdByUid(uid) ?? 0;

    trackedEntityAttribute.target =
        D2TrackedEntityAttributeRepository(db).getByUid(json["attribute"]);
    trackedEntity.target =
        D2TrackedEntityRepository(db).getByUid(trackedEntityId);
  }

  /// Constructs a new [D2TrackedEntityAttributeValue] from form values.
  ///
  /// - [value] The value of the tracked entity attribute.
  /// - [db] The database instance.
  /// - [trackedEntity] The tracked entity associated with the attribute value.
  /// - [trackedEntityAttribute] The tracked entity attribute.
  D2TrackedEntityAttributeValue.fromFormValues(this.value,
      {required D2ObjectBox db,
      required D2TrackedEntity trackedEntity,
      required D2TrackedEntityAttribute trackedEntityAttribute})
      : createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        uid = "${trackedEntity.uid}-${trackedEntityAttribute.uid}",
        synced = false {
    this.trackedEntityAttribute.target = trackedEntityAttribute;
    this.trackedEntity.target = trackedEntity;
  }

  /// Indicates whether the attribute value has been synced with the server.
  @override
  bool synced;

  /// Converts the [D2TrackedEntityAttributeValue] instance to a map.
  ///
  /// - [db] The database instance.
  ///
  /// Returns a map representation of the attribute value.
  @override
  Future<Map<String, dynamic>> toMap({D2ObjectBox? db}) async {
    return {"attribute": trackedEntityAttribute.target?.uid, "value": value};
  }

  /// Converts the attribute value to form values.
  ///
  /// Returns a map representation of the form values.
  @override
  Map<String, dynamic> toFormValues() {
    return {trackedEntityAttribute.target!.uid: value};
  }

  /// Saves the [D2TrackedEntityAttributeValue] instance to the database.
  ///
  /// - [db] The database instance.
  @override
  void save(D2ObjectBox db) {
    D2TrackedEntityAttributeValueRepository(db).saveEntity(this);
  }

  /// Gets the display value of the attribute.
  ///
  /// If the attribute has an option set, returns the display name or name of the option.
  /// Otherwise, returns the raw value.
  String? getDisplayValue() {
    if (trackedEntityAttribute.target!.optionSet.target == null) {
      return value;
    }
    D2OptionSet optionSet = trackedEntityAttribute.target!.optionSet.target!;
    D2Option? valueOption =
        optionSet.options.firstWhereOrNull((element) => element.code == value);
    return valueOption?.displayName ?? valueOption?.name ?? value;
  }

  /// Updates the attribute value from form values.
  ///
  /// - [values] The form values.
  /// - [db] The database instance.
  /// - [program] The program associated with the attribute value.
  /// - [orgUnit] The organization unit associated with the attribute value.
  @override
  void updateFromFormValues(Map<String, dynamic> values,
      {required D2ObjectBox db, D2Program? program, D2OrgUnit? orgUnit}) {
    String key = trackedEntityAttribute.target!.uid;
    if (values.containsKey(key)) {
      value = values[key];
      synced = false;
    }
  }
}
