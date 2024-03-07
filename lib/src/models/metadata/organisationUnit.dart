import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/orgUnit.dart';
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
  int level;
  @override
  DateTime created;

  @override
  DateTime lastUpdated;

  D2OrgUnit(this.id, this.displayName, this.name, this.uid, this.shortName,
      this.path, this.level, this.created, this.lastUpdated);

  D2OrgUnit.fromMap(ObjectBox db, Map json)
      : uid = json["id"],
        name = json["name"],
        shortName = json["shortName"],
        path = json["path"],
        level = json["level"],
        created = DateTime.parse(json["created"]),
        displayName = json["displayName"],
        lastUpdated = DateTime.parse(json["lastUpdated"]) {
    id = D2OrgUnitRepository(db).getIdByUid(json["id"]) ?? 0;
  }

  @override
  String? displayName;
}
