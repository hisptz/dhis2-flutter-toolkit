import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/category_combo.dart';
import 'base.dart';
import 'category.dart';
import 'category_option_combo.dart';

@Entity()
class D2CategoryCombo extends D2MetaResource {
  @override
  int id = 0;
  @override
  DateTime created;

  @override
  DateTime lastUpdated;

  @override
  String uid;

  String name;
  String code;
  bool skipTotal;
  String dataDimensionType;

  final dataElement = ToMany<D2DataElement>();
  @Backlink('categoryCombos')
  final categories = ToMany<D2Category>();
  @Backlink('categoryCombo')
  final categoryOptionCombos = ToMany<D2CategoryOptionCombo>();

  D2CategoryCombo(
    this.lastUpdated,
    this.uid,
    this.created,
    this.name,
    this.code,
    this.id,
    this.skipTotal,
    this.dataDimensionType,
  );

  D2CategoryCombo.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"]),
        uid = json["id"],
        name = json["name"],
        code = json["code"],
        dataDimensionType = json["dataDimensionType"],
        skipTotal = json['skipTotal'] {
    id = D2CategoryComboRepository(db).getIdByUid(json['id']) ?? 0;
  }
}
