import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/user_group.dart';
import 'base.dart';

@Entity()
class D2UserGroup extends D2MetaResource {
  @override
  int id = 0;

  /// The unique identifier for the user group.
  @override
  @Unique()
  String uid;

  /// The name of the user group.
  @Index()
  String name;

  /// The date and time when the user group was created.
  @override
  DateTime created;

  /// The date and time when the user group was last updated.
  @override
  DateTime lastUpdated;

  /// Creates a new [D2UserGroup] instance.
  ///
  /// - [id] The unique identifier for the user group.
  /// - [uid] The unique identifier for the user group.
  /// - [displayName] The display name of the user group.
  /// - [name] The name of the user group.
  /// - [created] The date and time when the user group was created.
  /// - [lastUpdated] The date and time when the user group was last updated.
  D2UserGroup(this.id, this.uid, this.displayName, this.name, this.created,
      this.lastUpdated);

  /// Creates a new [D2UserGroup] instance from a map.
  ///
  /// - [db] The database instance of type [D2ObjectBox].
  /// - [json] A map representing the user group data.
  D2UserGroup.fromMap(D2ObjectBox db, Map json)
      : uid = json["id"],
        name = json["name"],
        displayName = json["displayName"],
        created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"]) {
    id = D2UserGroupRepository(db).getIdByUid(json["id"]) ?? 0;
  }

  /// The display name of the user group.
  @override
  String? displayName;
}
