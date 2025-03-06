import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import '../../repositories/metadata/user.dart';
import 'base.dart';
import 'user_group.dart';
import 'user_role.dart';

@Entity()
class D2User extends D2MetaResource {
  @override
  int id = 0;
  String username;
  String firstName;
  String surname;
  String? email;
  List<String> authorities;
  List<String> programs;
  List<String> organisationUnits;
  List<String> dataSets;
  DateTime created;
  DateTime lastUpdated;
  DateTime? lastLogin;
  DateTime? passwordLastUpdated;

  final userRoles = ToMany<D2UserRole>();
  final userGroups = ToMany<D2UserGroup>();

  get fullName {
    return "$firstName $surname";
  }

  @override
  @Unique()
  String uid;

  D2User(this.username,
      this.firstName,
      this.surname,
      this.email,
      this.authorities,
      this.uid,
      this.programs,
      this.organisationUnits,
      this.created,
      this.lastUpdated,
      this.lastLogin,
      this.passwordLastUpdated,
      this.dataSets);

  D2User.fromMap(D2ObjectBox db, Map<String, dynamic> json)
      : uid = json["id"],
        username = json["username"],
        firstName = json["firstName"],
        surname = json["surname"],
        email = json["email"],
        authorities = json["authorities"].cast<String>(),
        dataSets = json["dataSets"].cast<String>(),
        programs = json["programs"].cast<String>(),
        created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"] ?? ''),
        lastLogin =
            DateTime.tryParse(json["userCredentials"]?["lastLogin"] ?? ''),
        passwordLastUpdated = DateTime.tryParse(
            json["userCredentials"]?["passwordLastUpdated"] ?? ''),
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

  @override
  String toString() {
    return "Username: $username, First Name: $firstName, Last Name: $surname, ID: $uid ";
  }
}
