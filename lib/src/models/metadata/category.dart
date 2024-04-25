import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import '../../repositories/metadata/category.dart';
import './base.dart';
import './category_option.dart';
import 'category_combo.dart';

@Entity()
class D2Category extends D2MetaResource {
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
  String shortName;
  String dataDimensionType;

  @Backlink('category')
  final categoryOptions = ToMany<D2CategoryOption>();

  final categoryCombos = ToMany<D2CategoryCombo>();

  D2Category(
    this.id,
    this.shortName,
    this.lastUpdated,
    this.name,
    this.code,
    this.created,
    this.dataDimensionType,
    this.uid,
  );

  D2Category.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json['created']),
        lastUpdated = DateTime.parse(json['lastUpdated']),
        uid = json['id'],
        name = json['name'],
        code = json['code'],
        dataDimensionType = json['dataDimensionType'],
        shortName = json['shortName'] {
    id = D2CategoryRepository(db).getIdByUid(json["id"]) ?? 0;
  }
}
