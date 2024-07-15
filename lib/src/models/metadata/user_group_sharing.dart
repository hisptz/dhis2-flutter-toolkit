import 'package:objectbox/objectbox.dart';

import 'sharing.dart';

@Entity()
class D2UserGroupSharing {
  int id = 0;

  String displayName;
  String access;
  String userGroupId;

  final sharing = ToOne<D2Sharing>();

  D2UserGroupSharing(this.id, this.displayName, this.access, this.userGroupId);

  //TODO: Create a uid for preventing duplication
  D2UserGroupSharing.fromMap(Map json, D2Sharing sharing)
      : userGroupId = json["id"],
        access = json["access"],
        displayName = json["displayName"] {
    this.sharing.target = sharing;
  }
}
