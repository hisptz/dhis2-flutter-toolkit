import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/user_role.dart';
import 'base.dart';

@Entity()

/// This class represents a user role in the DHIS2 system.
class D2UserRole extends D2MetaResource {
  @override
  int id = 0;

  /// Unique UID for the user role.
  @override
  @Unique()
  String uid;

  /// Name of the user role.
  String name;

  /// List of authorities assigned to the user role.
  List<String> authorities;

  /// Date and time when the user role was created.
  @override
  DateTime created;

  /// Date and time when the user role was last updated.
  @override
  DateTime lastUpdated;

  /// Constructs a [D2UserRole] instance with the given parameters.
  ///
  /// - [displayName] is the display name for the user role.
  /// - [uid] is the unique UID for the user role.
  /// - [name] is the name of the user role.
  /// - [authorities] is the list of authorities assigned to the user role.
  /// - [created] is the date and time when the user role was created.
  /// - [lastUpdated] is the date and time when the user role was last updated.
  D2UserRole(this.displayName, this.uid, this.name, this.authorities,
      this.created, this.lastUpdated);

  /// Creates a [D2UserRole] instance from a JSON map.
  ///
  /// - [db] The database instance of type [D2ObjectBox].
  /// - [json] A map representing the user roles data.
  D2UserRole.fromMap(D2ObjectBox db, Map json)
      : uid = json["id"],
        name = json["name"],
        displayName = json["displayName"],
        authorities = json["authorities"].cast<String>(),
        created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"]) {
    id = D2UserRoleRepository(db).getIdByUid(json["id"]) ?? 0;
  }

  /// Display name for the user role.
  @override
  String? displayName;
}
