import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import '../../repositories/metadata/user.dart';
import 'base.dart';
import 'user_group.dart';
import 'user_role.dart';

@Entity()

/// This class represents a user in the DHIS2 system.
class D2User extends D2MetaResource {
  /// The user's unique identifier.
  @override
  int id = 0;

  /// The user's username.
  String username;

  /// The user's first name.
  String firstName;

  /// The user's surname.
  String surname;

  /// The user's email address, if available.
  String? email;

  /// A list of authorities associated with the user.
  List<String> authorities;

  /// A list of programs associated with the user.
  List<String> programs;

  /// A list of organization units associated with the user.
  List<String> organisationUnits;

  /// A list of datasets associated with the user.
  List<String> dataSets;

  /// A relationship to the user's roles.
  final userRoles = ToMany<D2UserRole>();

  /// A relationship to the user's groups.
  final userGroups = ToMany<D2UserGroup>();

  /// Returns the user's full name by concatenating the first name and surname.
  get fullName {
    return "$firstName $surname";
  }

  /// The user's unique identifier (UID).
  @override
  @Unique()
  String uid;

  /// Creates a new [D2User] instance.
  ///
  /// Takes the following parameters:
  /// - [username] The user's username.
  /// - [firstName] The user's first name.
  /// - [surname] The user's surname.
  /// - [email] The user's email address, if available.
  /// - [authorities] A list of authorities associated with the user.
  /// - [uid] The user's unique identifier.
  /// - [programs] A list of programs associated with the user.
  /// - [organisationUnits] A list of organization units associated with the user.
  /// - [dataSets] A list of datasets associated with the user.
  D2User(
      {required this.username,
      required this.firstName,
      required this.surname,
      this.email,
      required this.authorities,
      required this.uid,
      required this.programs,
      required this.organisationUnits,
      required this.dataSets});

  /// Creates a new [D2User] instance from a map.
  ///
  /// - [db] Database instance used for data operations.
  /// - [json] Map containing the user's data.
  D2User.fromMap(D2ObjectBox db, Map<String, dynamic> json)
      : uid = json["id"],
        username = json["username"],
        firstName = json["firstName"],
        surname = json["surname"],
        email = json["email"],
        authorities = json["authorities"].cast<String>(),
        dataSets = json["dataSets"].cast<String>(),
        programs = json["programs"].cast<String>(),
        organisationUnits = json["organisationUnits"]
            .map((orgUnit) => orgUnit["id"])
            .toList()
            .cast<String>() {
    id = D2UserRepository(db).getIdByUid(json["id"]) ?? 0;
    List<D2UserRole> roles = json["userRoles"]
        .cast<Map>()
        .map<D2UserRole>((Map json) => D2UserRole.fromMap(db, json))
        .toList()
        .cast<D2UserRole>();
    userRoles.addAll(roles);
    List<D2UserGroup> groups = json["userGroups"]
        .cast<Map>()
        .map<D2UserGroup>((Map json) => D2UserGroup.fromMap(db, json))
        .toList()
        .cast<D2UserGroup>();
    userGroups.addAll(groups);
  }

  /// Returns a [String] representation of the user. containing the user's username, first name, surname, and UID.
  @override
  String toString() {
    return "Username: $username, First Name: $firstName, Last Name: $surname, ID: $uid ";
  }
}
