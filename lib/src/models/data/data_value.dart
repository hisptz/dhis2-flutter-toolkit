import 'package:collection/collection.dart';
import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import '../../repositories/data/entry.dart';
import '../../repositories/metadata/entry.dart';
import '../metadata/entry.dart';
import 'base.dart';
import 'base_editable.dart';
import 'event.dart';
import 'upload_base.dart';

@Entity()

/// This class represents a data value in the DHIS2 system.
class D2DataValue extends D2DataResource
    implements SyncableData, D2BaseEditable {
  @override
  int id = 0;
  @override
  DateTime createdAt;
  @override
  DateTime updatedAt;

  @Unique()
  String uid;

  String? value;
  bool providedElsewhere;

  final event = ToOne<D2Event>();

  final dataElement = ToOne<D2DataElement>();

  /// Constructs a new instance of [D2DataValue].
  ///
  /// - [uid] The unique identifier for the data value.
  /// - [id] The ID of the data value.
  /// - [createdAt] The creation timestamp of the data value.
  /// - [updatedAt] The last updated timestamp of the data value.
  /// - [value] The value stored.
  /// - [providedElsewhere] Whether the value is provided elsewhere.
  /// - [synced] Whether the value is synced.
  D2DataValue(this.uid, this.id, this.createdAt, this.updatedAt, this.value,
      this.providedElsewhere, this.synced);

  /// Constructs a new instance of [D2DataValue] from a map.
  ///
  /// - [db] The database reference for fetching related entities.
  /// - [json] The JSON map containing data value information.
  /// - [eventId] The event ID related to the data value.
  D2DataValue.fromMap(D2ObjectBox db, Map json, String eventId)
      : updatedAt = DateTime.parse(json["updatedAt"]),
        createdAt = DateTime.parse(json["createdAt"]),
        uid = "$eventId-${json["dataElement"]}",
        value = json["value"],
        providedElsewhere = json["providedElsewhere"] {
    String uid = "$eventId-${json["dataElement"]}";
    id = D2DataValueRepository(db).getIdByUid(uid) ?? 0;

    event.target = D2EventRepository(db).getByUid(eventId);
    dataElement.target =
        D2DataElementRepository(db).getByUid(json["dataElement"]);
  }

  /// Constructs a new instance of [D2DataValue] from form values.
  ///
  /// - [value] The value to be stored.
  /// - [event] The related event.
  /// - [dataElement] The related data element.
  D2DataValue.fromFormValues(this.value,
      {required D2Event event, required D2DataElement dataElement})
      : updatedAt = DateTime.now(),
        createdAt = DateTime.now(),
        uid = "${event.uid}-${dataElement.uid}",
        providedElsewhere = false {
    this.event.target = event;
    this.dataElement.target = dataElement;
  }

  @override
  bool synced = true;

  /// Retrieves the display value of the data element.
  ///
  /// Returns the display value as [String].
  String? getDisplayValue() {
    if (dataElement.target!.optionSet.target == null) {
      return value;
    }
    D2OptionSet optionSet = dataElement.target!.optionSet.target!;
    D2Option? valueOption =
        optionSet.options.firstWhereOrNull((element) => element.code == value);
    return valueOption?.displayName ?? valueOption?.name ?? value;
  }

  /// Converts the data value to a map.
  ///
  /// - [db] The database reference, optional.
  ///
  /// Returns a [Future] containing the map of data value information.
  @override
  Future<Map<String, dynamic>> toMap({D2ObjectBox? db}) async {
    return {"dataElement": dataElement.target?.uid, "value": value};
  }

  /// Converts the data value to form values.
  ///
  /// Returns a map of form values.
  @override
  Map<String, dynamic> toFormValues() {
    return {dataElement.target!.uid: value};
  }

  /// Updates the data value from form values.
  ///
  /// - [values] The map of form values.
  /// - [db] The database reference.
  /// - [program] The related program, optional.
  /// - [orgUnit] The related organisation unit, optional.
  @override
  void updateFromFormValues(Map<String, dynamic> values,
      {required D2ObjectBox db, D2Program? program, D2OrgUnit? orgUnit}) {
    String key = dataElement.target!.uid;
    if (values.containsKey(key)) {
      value = values[key];
      synced = false;
    }
  }

  /// Saves the data value to the database.
  ///
  /// - [db] The database reference.
  @override
  void save(D2ObjectBox db) {
    D2DataValueRepository(db).saveEntity(this);
  }
}
