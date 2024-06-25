import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/org_unit_level.dart';
import 'base.dart';

@Entity()

/// This class represents an organizational unit level in the DHIS2 system.
class D2OrgUnitLevel implements D2MetaResource {
  /// The unique identifier of the organizational unit level.
  @override
  int id = 0;

  /// The name of the organizational unit level.
  String name;

  @override
  @Unique()
  String uid;

  /// The level of the organizational unit.
  int level;

  /// The date and time when the organizational unit level was created.
  @override
  DateTime created;

  /// The date and time when the organizational unit level was last updated.
  @override
  DateTime lastUpdated;

  /// Constructs a [D2OrgUnitLevel].
  ///
  /// Parameters:
  /// - [id] The unique identifier of the organizational unit level.
  /// - [displayName] The display name of the organizational unit level.
  /// - [name] The name of the organizational unit level.
  /// - [uid] The unique UID of the organizational unit level.
  /// - [level] The level of the organizational unit.
  /// - [created] The date and time when the organizational unit level was created.
  /// - [lastUpdated] The date and time when the organizational unit level was last updated.
  D2OrgUnitLevel(this.id, this.displayName, this.name, this.uid, this.level,
      this.created, this.lastUpdated);

  /// Constructs a [D2OrgUnitLevel] from a map [json].
  ///
  /// - [db] The database instance.
  /// - [json] The map containing the organizational unit level data.
  D2OrgUnitLevel.fromMap(D2ObjectBox db, Map json)
      : name = json["name"],
        uid = json["id"],
        level = json["level"],
        displayName = json["displayName"],
        created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"]) {
    id = D2OrgUnitLevelRepository(db).getIdByUid(json["id"]) ?? 0;
  }

  /// The display name of the organizational unit level.
  @override
  String? displayName;
}
