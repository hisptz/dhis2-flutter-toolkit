import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:objectbox/objectbox.dart';

import 'base.dart';

@Entity()
class D2CategoryCombo extends D2MetaResource {
  @override
  int id = 0;
  DateTime created;

  DateTime lastUpdated;

  @override
  @Unique()
  String uid;

  String name;
  String? code;
  bool skipTotal;
  String dataDimensionType;

  @Backlink('categoryCombo')
  final categoryOptionCombos = ToMany<D2CategoryOptionCombo>();

  final categories = ToMany<D2Category>();

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

    List<D2Category> categories = json['categories']
        .cast<Map>()
        .map((Map json) => D2CategoryRepository(db).getByUid(json['id']))
        .toList()
        .cast<D2Category>();

    this.categories.addAll(categories);
  }
}
