import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import '../../repositories/metadata/org_unit.dart';
import '../../repositories/metadata/org_unit_level.dart';
import '../data/data_value_set.dart';
import 'base.dart';
import 'org_unit_level.dart';

@Entity()

/// This class represents an organizational unit in a DHIS2 system.
class D2OrgUnit implements D2MetaResource {
  /// Unique identifier of the organizational unit.
  @override
  int id = 0;

  /// Name of the organizational unit.
  String name;

  /// Short name of the organizational unit.
  String shortName;

  @override
  @Unique()
  String uid;

  /// Path representing the hierarchy of the organizational unit.
  String path;

  /// Optional code of the organizational unit.
  String? code;

  /// Date when the organizational unit was created.
  DateTime created;

  /// Date when the organizational unit was opened.
  DateTime openingDate;

  /// Date when the organizational unit was last updated.
  DateTime lastUpdated;

  /// Reference to the parent organizational unit.
  final parent = ToOne<D2OrgUnit>();

  /// Reference to the level of the organizational unit.
  final level = ToOne<D2OrgUnitLevel>();

  /// List of data value sets associated with the organizational unit.
  final dataValues = ToMany<D2DataValueSet>();

  /// List of child organizational units.
  @Backlink("parent")
  final children = ToMany<D2OrgUnit>();

  /// Constructs a [D2OrgUnit].
  ///
  /// - [id]: Unique identifier of the organizational unit.
  /// - [displayName]: Display name of the organizational unit.
  /// - [name]: Name of the organizational unit.
  /// - [uid]: Unique identifier string (UID) of the organizational unit.
  /// - [shortName]: Short name of the organizational unit.
  /// - [path]: Path representing the hierarchy of the organizational unit.
  /// - [created]: Date when the organizational unit was created.
  /// - [lastUpdated]: Date when the organizational unit was last updated.
  /// - [openingDate]: Date when the organizational unit was opened.
  /// - [code]: Optional code of the organizational unit.
  D2OrgUnit(this.id, this.displayName, this.name, this.uid, this.shortName,
      this.path, this.created, this.lastUpdated, this.openingDate, this.code);

  /// Constructs a [D2OrgUnit] from a JSON map.
  ///
  /// - [db]: The [D2ObjectBox] instance.
  /// - [json]: The JSON [Map] containing organizational unit data.
  D2OrgUnit.fromMap(D2ObjectBox db, Map json)
      : uid = json["id"],
        name = json["name"],
        shortName = json["shortName"],
        path = json["path"],
        created = DateTime.parse(json["created"]),
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

  /// Display name of the organizational unit.
  String? displayName;
}
