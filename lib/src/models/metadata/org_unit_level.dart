import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/org_unit_level.dart';
import 'base.dart';

@Entity()
class D2OrgUnitLevel implements D2MetaResource {
  @override
  int id = 0;

  String name;
  @override
  @Unique()
  String uid;
  int level;

  @override
  DateTime created;

  @override
  DateTime lastUpdated;

  D2OrgUnitLevel(this.id, this.displayName, this.name, this.uid,
      this.level, this.created, this.lastUpdated);

  D2OrgUnitLevel.fromMap(D2ObjectBox db, Map json)
      : name = json["name"],
        uid = json["id"],
        level = json["level"],
        displayName = json["displayName"],
        created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"]) {
    id = D2OrgUnitLevelRepository(db).getIdByUid(json["id"]) ?? 0;
  }

  @override
  String? displayName;
}
