import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:objectbox/objectbox.dart';

import 'base.dart';

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
  @override
  DateTime created;
  DateTime openingDate;

  @override
  DateTime lastUpdated;

  final parent = ToOne<D2OrgUnit>();

  final level = ToOne<D2OrgUnitLevel>();

  @Backlink("parent")
  final children = ToMany<D2OrgUnit>();

  D2OrgUnit(this.id, this.displayName, this.name, this.uid, this.shortName,
      this.path, this.created, this.lastUpdated, this.openingDate);

  D2OrgUnit.fromMap(D2ObjectBox db, Map json)
      : uid = json["id"],
        name = json["name"],
        shortName = json["shortName"],
        path = json["path"],
        created = DateTime.parse(json["created"]),
        openingDate = DateTime.parse(json["openingDate"]),
        displayName = json["displayName"],
        lastUpdated = DateTime.parse(json["lastUpdated"]) {
    id = D2OrgUnitRepository(db).getIdByUid(json["id"]) ?? 0;
    parent.target = D2OrgUnitRepository(db).getByUid(json["parent"]["id"]);
    level.target = D2OrgUnitLevelRepository(db).getByLevel(json["level"]);
  }

  @override
  String? displayName;
}
