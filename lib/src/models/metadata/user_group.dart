import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/user_group.dart';
import 'base.dart';

@Entity()
class D2UserGroup extends D2MetaResource {
  @override
  int id = 0;
  @override
  @Unique()
  String uid;
  @Index()
  String name;

  @override
  DateTime created;

  @override
  DateTime lastUpdated;

  D2UserGroup(this.id, this.uid, this.displayName, this.name, this.created,
      this.lastUpdated);

  D2UserGroup.fromMap(D2ObjectBox db, Map json)
      : uid = json["id"],
        name = json["name"],
        displayName = json["displayName"],
        created = DateTime.parse(json["created"] ?? json["createdAt"]),
        lastUpdated =
            DateTime.parse(json["lastUpdated"] ?? json[" updatedAt"]) {
    id = D2UserGroupRepository(db).getIdByUid(json["id"]) ?? 0;
  }

  @override
  String? displayName;
}
