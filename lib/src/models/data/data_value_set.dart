import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:objectbox/objectbox.dart';

import 'upload_base.dart';

@Entity()
class D2DataValueSet extends D2DataResource implements SyncableData {
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

  D2DataValueSet(
    this.uid,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.value,
    this.period,
    this.comment,
  );

  final dataElement = ToOne<D2DataElement>();
  final categoryOptionCombo = ToOne<D2CategoryOptionCombo>();
  final attributeOptionCombo = ToOne<D2CategoryOptionCombo>();
  final organisationUnit = ToOne<D2OrgUnit>();

  D2DataValueSet.fromMap(D2ObjectBox db, Map json)
      : updatedAt = DateTime.parse(json["updatedAt"]),
        createdAt = DateTime.parse(json["createdAt"]),
        value = json["value"],
        period = json["period"],
        comment = json["comment"] {
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

  D2DataValueSet.fromForm(
      {required D2ObjectBox db,
      required D2OrgUnit orgUnit,
      required D2CategoryOptionCombo attributeOptionCombo,
      required this.period,
      required this.value,
      required D2DataElement dataElement,
      required D2CategoryOptionCombo categoryOptionCombo})
      : createdAt = DateTime.now(),
        updatedAt = DateTime.now() {
    organisationUnit.target = orgUnit;
    this.attributeOptionCombo.target = attributeOptionCombo;
    this.dataElement.target = dataElement;
    this.categoryOptionCombo.target = categoryOptionCombo;
    uid =
        '${orgUnit.uid}-$period-${attributeOptionCombo.uid}-${dataElement.uid}-${categoryOptionCombo.uid}';
    id = D2DataValueSetRepository(db).getIdByUid(uid) ?? 0;
    synced = false;
  }

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

  Map<String, dynamic> toFormValues() {
    if (categoryOptionCombo.target != null) {
      return {
        '${dataElement.target!.uid}.${categoryOptionCombo.target!.uid}': value
      };
    }

    return {dataElement.target!.uid: value};
  }

  void save(D2ObjectBox db) {
    db.store.box<D2DataValueSet>().put(this);
  }
}
