import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/org_unit_group.dart';
import 'base.dart';
import 'org_unit.dart';

@Entity()
class D2OrgUnitGroup implements D2MetaResource {
  @override
  int id = 0;
  String name;
  @override
  @Unique()
  String uid;

  final organisationUnits = ToMany<D2OrgUnit>();

  @override
  DateTime created;

  @override
  DateTime lastUpdated;

  D2OrgUnitGroup(this.id, this.displayName, this.name, this.uid, this.created,
      this.lastUpdated);

  D2OrgUnitGroup.fromMap(ObjectBox db, Map json)
      : name = json["name"],
        uid = json["id"],
        displayName = json["displayName"],
        created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"]) {
    List<D2OrgUnit> orgUnits = json["organisationUnits"]
        .map((Map json) => D2OrgUnit.fromMap(db, json));
    organisationUnits.addAll(orgUnits);
    id = D2OrgUnitGroupRepository(db).getIdByUid(json["id"]) ?? 0;
  }

  @override
  String? displayName;
}
