import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import '../../repositories/metadata/org_unit.dart';
import '../../repositories/metadata/org_unit_group.dart';
import 'base.dart';
import 'org_unit.dart';

@Entity()

/// This class represents a group of organizational units in the DHIS2 system.
class D2OrgUnitGroup implements D2MetaResource {
  /// Unique identifier of the organizational unit group.
  @override
  int id = 0;

  /// Name of the organizational unit group.
  String name;

  @override
  @Unique()
  String uid;

  /// List of organizational units in the group.
  final organisationUnits = ToMany<D2OrgUnit>();

  /// Date when the organizational unit group was created.
  DateTime created;

  /// Date when the organizational unit group was last updated.
  DateTime lastUpdated;

  /// Constructs a [D2OrgUnitGroup].
  ///
  /// Parameters:
  /// - [id]: Unique identifier of the organizational unit group.
  /// - [displayName]: Display name of the organizational unit group.
  /// - [name]: Name of the organizational unit group.
  /// - [uid]: Unique identifier string (UID) of the organizational unit group.
  /// - [created]: Date when the organizational unit group was created.
  /// - [lastUpdated]: Date when the organizational unit group was last updated.
  D2OrgUnitGroup(this.id, this.displayName, this.name, this.uid, this.created,
      this.lastUpdated);

  /// Constructs a [D2OrgUnitGroup] from a JSON map.
  ///
  /// Parameters:
  /// - [db]: The [D2ObjectBox] instance.
  /// - [json]: The JSON [Map] containing organizational unit group data.
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

  /// Display name of the organizational unit group.
  String? displayName;
}
