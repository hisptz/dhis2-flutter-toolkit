import 'package:objectbox/objectbox.dart';

import 'sharing.dart';

@Entity()
class D2UserSharing {
  int id = 0;

  final sharing = ToOne<D2Sharing>();

  String displayName;
  String access;
  String userId;

  D2UserSharing(this.id, this.displayName, this.access, this.userId);

  D2UserSharing.fromMap(Map json, D2Sharing sharing)
      : userId = json["id"],
        access = json["access"],
        displayName = json["displayName"] {
    this.sharing.target = sharing;
  }
}
