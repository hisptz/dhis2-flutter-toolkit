import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/program.dart';
import '../../repositories/metadata/program_tracked_entity_attribute.dart';
import '../../repositories/metadata/tracked_entity_attribute.dart';
import 'base.dart';
import 'program.dart';
import 'tracked_entity_attribute.dart';

@Entity()

/// This class represents a tracked entity attribute in a program in the DHIS2 system.
///
/// This class extends [D2MetaResource] and includes additional properties
/// specific to program tracked entity attributes.
class D2ProgramTrackedEntityAttribute extends D2MetaResource {
  /// The date and time when the tracked entity attribute was created.
  DateTime created;

  @override
  int id = 0;

  /// The date and time when the tracked entity attribute was last updated.
  DateTime lastUpdated;

  /// The unique UID of the tracked entity attribute.
  @override
  String uid;

  /// The order in which the tracked entity attribute is sorted.
  int sortOrder;

  /// Whether the tracked entity attribute is displayed in a list.
  bool? displayInList;

  /// Whether the tracked entity attribute is mandatory.
  bool mandatory;

  /// Whether the tracked entity attribute is searchable.
  bool? searchable;

  /// Whether the tracked entity attribute renders options as radio buttons.
  bool? renderOptionsAsRadio;

  /// Whether the tracked entity attribute allows future dates.
  bool? allowFutureDate;

  /// Whether the tracked entity attribute has an option set value.
  bool? optionSetValue;

  /// Reference to the associated program.
  final program = ToOne<D2Program>();

  /// Reference to the associated tracked entity attribute.
  final trackedEntityAttribute = ToOne<D2TrackedEntityAttribute>();

  /// Creates a new instance of [D2ProgramTrackedEntityAttribute].
  ///
  /// - [created] is the creation date and time.
  /// - [id] is the unique identifier.
  /// - [lastUpdated] is the last update date and time.
  /// - [uid] is the unique UID.
  /// - [sortOrder] is the order in which the attribute is sorted.
  /// - [displayInList] specifies if the attribute is displayed in a list.
  /// - [mandatory] specifies if the attribute is mandatory.
  /// - [searchable] specifies if the attribute is searchable.
  /// - [renderOptionsAsRadio] specifies if the attribute renders options as radio buttons.
  /// - [allowFutureDate] specifies if the attribute allows future dates.
  /// - [optionSetValue] specifies if the attribute has an option set value.
  D2ProgramTrackedEntityAttribute(
      this.created,
      this.id,
      this.lastUpdated,
      this.uid,
      this.sortOrder,
      this.displayInList,
      this.mandatory,
      this.searchable,
      this.renderOptionsAsRadio,
      this.allowFutureDate,
      this.optionSetValue);

  /// Creates a new instance of [D2ProgramTrackedEntityAttribute] from a map.
  ///
  /// - [db] is the database instance.
  /// - [json] is the map containing the data to initialize the instance.
  D2ProgramTrackedEntityAttribute.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"]),
        uid = json["id"],
        sortOrder = json["sortOrder"],
        displayInList = json["displayInList"],
        mandatory = json["mandatory"],
        searchable = json["searchable"],
        renderOptionsAsRadio = json["renderOptionsAsRadio"],
        allowFutureDate = json["allowFutureDate"],
        optionSetValue = json["optionSetValue"] {
    id = D2ProgramTrackedEntityAttributeRepository(db).getIdByUid(json["id"]) ??
        0;
    D2TrackedEntityAttribute? attribute = D2TrackedEntityAttributeRepository(db)
        .getByUid(json["trackedEntityAttribute"]["id"]);
    trackedEntityAttribute.target = attribute;
    program.target = D2ProgramRepository(db).getByUid(json["program"]["id"]);
  }

  /// The display name of the tracked entity attribute.
  String? displayName;
}
