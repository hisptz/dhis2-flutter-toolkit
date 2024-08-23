import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import '../../repositories/metadata/org_unit.dart';
import '../../repositories/metadata/org_unit_level.dart';
import '../data/data_value_set.dart';
import 'base.dart';
import 'org_unit_level.dart';

@Entity()
class D2OrgUnit implements D2MetaResource {
  @override
  int id = 0;
  String name;
  String shortName;
  @override
  @Unique()
  String uid;
  String path;
  String? code;
  DateTime created;
  DateTime openingDate;
  DateTime lastUpdated;

  final parent = ToOne<D2OrgUnit>();

  final level = ToOne<D2OrgUnitLevel>();
  final dataValues = ToMany<D2DataValueSet>();

  @Backlink("parent")
  final children = ToMany<D2OrgUnit>();

  D2OrgUnit(this.id, this.displayName, this.name, this.uid, this.shortName,
      this.path, this.created, this.lastUpdated, this.openingDate, this.code);

  D2OrgUnit.fromMap(D2ObjectBox db, Map json)
      : uid = json["id"],
        name = json["name"],
        shortName = json["shortName"],
        path = json["path"],
        created = DateTime.parse(json["created"] ?? json["createdAt"]),
        openingDate = DateTime.parse(json["openingDate"]),
        displayName = json["displayName"],
        code = json["code"],
        lastUpdated = DateTime.parse(json["lastUpdated"]) {
    id = D2OrgUnitRepository(db).getIdByUid(json["id"]) ?? 0;
    if (json["parent"] != null) {
      parent.target = D2OrgUnitRepository(db).getByUid(json["parent"]["id"]);
    }
    level.target = D2OrgUnitLevelRepository(db).getByLevel(json["level"]);
  }

  String? displayName;
}
