import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import '../../repositories/metadata/org_unit.dart';
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

  DateTime created;

  DateTime lastUpdated;

  D2OrgUnitGroup(this.id, this.displayName, this.name, this.uid, this.created,
      this.lastUpdated);

  D2OrgUnitGroup.fromMap(D2ObjectBox db, Map json)
      : name = json["name"],
        uid = json["id"],
        displayName = json["displayName"],
        created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"]) {
    id = D2OrgUnitGroupRepository(db).getIdByUid(json["id"]) ?? 0;

    List<D2OrgUnit?> orgUnits = json["organisationUnits"]
        .map<D2OrgUnit?>((json) => D2OrgUnitRepository(db).getByUid(json["id"]))
        .toList();
    List<D2OrgUnit> availableOrgUnits =
        orgUnits.where((element) => element != null).toList().cast<D2OrgUnit>();
    organisationUnits.addAll(availableOrgUnits);
  }

  String? displayName;
}
