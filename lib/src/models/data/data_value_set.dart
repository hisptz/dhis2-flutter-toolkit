import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import '../../repositories/data/data_value_set.dart';
import '../../repositories/metadata/category_option_combo.dart';
import '../../repositories/metadata/data_element.dart';
import '../../repositories/metadata/org_unit.dart';
import '../metadata/category_option_combo.dart';
import '../metadata/data_element.dart';
import '../metadata/org_unit.dart';
import 'base.dart';
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

  @Unique()
  String uid;

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
        uid = [
          json["dataElement"],
          (json["attributeOptionCombo"] ?? json["categoryOptionCombo"])
        ].join("-"),
        value = json["value"],
        period = json["period"],
        comment = json["comment"] {
    id = D2DataValueSetRepository(db).getIdByUid(uid) ?? 0;
    dataElement.target =
        D2DataElementRepository(db).getByUid(json["dataElement"]);
    organisationUnit.target = D2OrgUnitRepository(db).getByUid(json["orgUnit"]);
    categoryOptionCombo.target = D2CategoryOptionComboRepository(db)
        .getByUid(json["categoryOptionCombo"]);
    attributeOptionCombo.target = D2CategoryOptionComboRepository(db)
        .getByUid(json["attributeOptionCombo"]);
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
    return {dataElement.target!.uid: value};
  }
}
