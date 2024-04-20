import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import '../../repositories/metadata/category_combo.dart';
import 'base.dart';
import 'category.dart';

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

  @Backlink('categoryCombos')
  final categories = ToMany<D2Category>();

  D2CategoryCombo(
    this.lastUpdated,
    this.uid,
    this.created,
    this.name,
    this.code,
    this.id,
    this.skipTotal,
  );

  D2CategoryCombo.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"]),
        uid = json["id"],
        name = json["name"],
        code = json["code"],
        skipTotal = json['skipTotal'] {
    id = D2CategoryComboRepository(db).getIdByUid(json['id']) ?? 0;
  }
}
