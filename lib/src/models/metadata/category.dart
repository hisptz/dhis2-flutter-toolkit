import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:objectbox/objectbox.dart';

import './base.dart';

@Entity()
class D2Category extends D2MetaResource {
  @override
  int id = 0;
  DateTime created;

  DateTime lastUpdated;

  @override
  @Unique()
  String uid;

  String name;
  String? code;
  String shortName;
  String dataDimensionType;

  @Backlink('category')
  final categoryOptions = ToMany<D2CategoryOption>();

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
      : created = DateTime.parse(json['created'] ?? json['createdAt']),
        lastUpdated = DateTime.parse(json['lastUpdated'] ?? json['updatedAt']),
        uid = json['id'],
        name = json['name'],
        code = json['code'],
        dataDimensionType = json['dataDimensionType'],
        shortName = json['shortName'] {
    id = D2CategoryRepository(db).getIdByUid(json["id"]) ?? 0;

    List<D2CategoryOption> options = json['categoryOptions']
        .cast<Map>()
        .map((Map json) => D2CategoryOptionRepository(db).getByUid(json['id']))
        .toList()
        .cast<D2CategoryOption>();
    categoryOptions.addAll(options);
  }
}
