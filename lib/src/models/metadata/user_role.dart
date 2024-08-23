import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/user_role.dart';
import 'base.dart';

@Entity()
class D2UserRole extends D2MetaResource {
  @override
  int id = 0;
  @override
  @Unique()
  String uid;
  String name;
  List<String> authorities;

  @override
  DateTime created;

  @override
  DateTime lastUpdated;

  D2UserRole(this.displayName, this.uid, this.name, this.authorities,
      this.created, this.lastUpdated);

  D2UserRole.fromMap(D2ObjectBox db, Map json)
      : uid = json["id"],
        name = json["name"],
        displayName = json["displayName"],
        authorities = json["authorities"].cast<String>(),
        created = DateTime.parse(json["created"] ?? json["createdAt"]),
        lastUpdated = DateTime.parse(json["lastUpdated"] ?? json["updatedAt"]) {
    id = D2UserRoleRepository(db).getIdByUid(json["id"]) ?? 0;
  }

  @override
  String? displayName;
}
