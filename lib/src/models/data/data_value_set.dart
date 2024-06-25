import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:objectbox/objectbox.dart';

import 'base.dart';
import 'base_deletable.dart';

@Entity()

/// This class represents a data value set in the DHIS2 system.
class D2DataValueSet extends SyncDataSource implements D2BaseDeletable {
  @override
  int id = 0;
  @override
  DateTime createdAt;
  @override
  DateTime updatedAt;
  @override
  bool synced = true;

  ///For this to be unique, it has to include orgUnit, period, attributeOptionCombo, dataElement, and categoryOptionCombo. So it is generated with the format as listed separated by -

  @Unique()
  late String uid;

  String value;
  String period;
  String? comment;
  bool followup;

  D2DataValueSet(this.uid, this.id, this.createdAt, this.updatedAt, this.value,
      this.period, this.comment, this.followup);

  final dataElement = ToOne<D2DataElement>();
  final categoryOptionCombo = ToOne<D2CategoryOptionCombo>();
  final attributeOptionCombo = ToOne<D2CategoryOptionCombo>();
  final organisationUnit = ToOne<D2OrgUnit>();

  /// Creates an instance of [D2DataValueSet] from a JSON map.
  ///
  /// - [db] The database reference.
  /// - [json] The JSON map containing the data value set information.
  D2DataValueSet.fromMap(D2ObjectBox db, Map json)
      : updatedAt = DateTime.parse(json["lastUpdated"]),
        createdAt = DateTime.parse(json["created"]),
        value = json["value"],
        period = json["period"],
        comment = json["comment"],
        followup = json['followup'] {
    dataElement.target =
        D2DataElementRepository(db).getByUid(json["dataElement"]);
    organisationUnit.target = D2OrgUnitRepository(db).getByUid(json["orgUnit"]);
    categoryOptionCombo.target = D2CategoryOptionComboRepository(db)
        .getByUid(json["categoryOptionCombo"]);
    attributeOptionCombo.target = D2CategoryOptionComboRepository(db)
        .getByUid(json["attributeOptionCombo"]);

    uid =
        '${organisationUnit.target!.uid}-$period-${attributeOptionCombo.target!.uid}-${dataElement.target!.uid}-${categoryOptionCombo.target!.uid}';

    id = D2DataValueSetRepository(db).getIdByUid(uid) ?? 0;
  }

  /// Creates an instance of [D2DataValueSet] from form values.
  ///
  /// - [db] The database reference.
  /// - [orgUnit] The organization unit.
  /// - [attributeOptionCombo] The attribute option combo.
  /// - [period] The period.
  /// - [value] The value.
  /// - [dataElement] The data element.
  /// - [categoryOptionCombo] The category option combo.
  D2DataValueSet.fromForm(
      {required D2ObjectBox db,
      required D2OrgUnit orgUnit,
      required D2CategoryOptionCombo attributeOptionCombo,
      required this.period,
      required this.value,
      required D2DataElement dataElement,
      required D2CategoryOptionCombo categoryOptionCombo})
      : createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        followup = false {
    organisationUnit.target = orgUnit;
    this.attributeOptionCombo.target = attributeOptionCombo;
    this.dataElement.target = dataElement;
    this.categoryOptionCombo.target = categoryOptionCombo;
    uid =
        '${orgUnit.uid}-$period-${attributeOptionCombo.uid}-${dataElement.uid}-${categoryOptionCombo.uid}';
    id = D2DataValueSetRepository(db).getIdByUid(uid) ?? 0;
    synced = false;
  }

  /// Converts the data value set to a JSON map.
  ///
  /// - [db] Optional database reference.
  ///
  /// Returns a [Future<Map<String, dynamic>>] containing the JSON map.
  @override
  Future<Map<String, dynamic>> toMap({D2ObjectBox? db}) async {
    return {
      "dataElement": dataElement.target?.uid,
      "value": value,
      "comment": comment,
      "period": period,
      "orgUnit": organisationUnit.target?.uid,
      "categoryOptionCombo": categoryOptionCombo.target?.uid,
      "attributeOptionCombo": attributeOptionCombo.target?.uid,
    };
  }

  /// Converts the data value set to form values.
  ///
  /// Returns a [Map] containing the form values.
  Map<String, dynamic> toFormValues() {
    if (categoryOptionCombo.target != null) {
      return {
        '${dataElement.target!.uid}.${categoryOptionCombo.target!.uid}': value
      };
    }
    return {dataElement.target!.uid: value};
  }

  /// Saves the data value set to the database.
  ///
  /// - [db] The database reference.
  void save(D2ObjectBox db) {
    db.store.box<D2DataValueSet>().put(this);
  }

  /// Deletes the data value set from the database.
  ///
  /// - [db] The database reference.
  ///
  /// Returns a [bool] indicating the success of the operation.
  @override
  bool delete(D2ObjectBox db) {
    return D2DataValueSetRepository(db).box.remove(id);
  }

  /// Soft deletes the data value set.
  ///
  /// - [db] The database reference.
  @override
  void softDelete(db) {}
}
