import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import '../../repositories/metadata/entry.dart';
import 'base.dart';
import 'category_combo.dart';
import 'category_option.dart';

@Entity()
class D2CategoryOptionCombo extends D2MetaResource {
  @override
  int id = 0;
  DateTime created;

  DateTime lastUpdated;

  @override
  String uid;

  String name;
  String? code;

  final categoryCombo = ToOne<D2CategoryCombo>();

  final categoryOptions = ToMany<D2CategoryOption>();

  D2CategoryOptionCombo(
    this.lastUpdated,
    this.uid,
    this.created,
    this.name,
    this.code,
    this.id,
  );

  D2CategoryOptionCombo.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"]),
        uid = json["id"],
        name = json["name"],
        code = json["code"] {
    id = D2CategoryOptionComboRepository(db).getIdByUid(json['id']) ?? 0;
    Map? categoryCombo = json['categoryCombo'];
    if (categoryCombo != null) {
      this.categoryCombo.target =
          D2CategoryComboRepository(db).getByUid(categoryCombo['id']);
    }

    List<D2CategoryOption> options = json['categoryOptions']
        .cast<Map>()
        .map((Map json) => D2CategoryOptionRepository(db).getByUid(json['id']))
        .toList()
        .cast<D2CategoryOption>();
    categoryOptions.addAll(options);
  }
}
