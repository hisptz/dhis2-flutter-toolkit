import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import '../../repositories/metadata/category_option.dart';
import './base.dart';
import 'category.dart';
import 'category_option_combo.dart';

@Entity()
class D2CategoryOption extends D2MetaResource {
  @override
  int id = 0;
  DateTime created;

  DateTime lastUpdated;

  @Unique()
  @override
  String uid;

  String name;
  String? code;
  String shortName;

  final category = ToOne<D2Category>();

  final categoryOptionCombo = ToOne<D2CategoryOptionCombo>();

  D2CategoryOption(
    this.id,
    this.created,
    this.lastUpdated,
    this.uid,
    this.name,
    this.code,
    this.shortName,
  );

  D2CategoryOption.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json["created"] ?? json["createdAt"]),
        lastUpdated = DateTime.parse(json["lastUpdated"] ?? json["updatedAt"]),
        uid = json["id"],
        name = json["name"],
        code = json["code"],
        shortName = json["shortName"] {
    id = D2CategoryOptionRepository(db).getIdByUid(json["id"]) ?? 0;
  }
}
