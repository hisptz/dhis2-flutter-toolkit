import '../../../objectbox.dart';
import '../../../objectbox.g.dart';
import '../../models/metadata/sharing.dart';
import '../../models/metadata/user_group_sharing.dart';
import '../../models/metadata/user_sharing.dart';

class D2SharingRepository {
  D2ObjectBox db;

  Box<D2UserGroupSharing> get userGroupBox {
    return db.store.box<D2UserGroupSharing>();
  }

  Box<D2UserSharing> get userBox {
    return db.store.box<D2UserSharing>();
  }

  Box<D2Sharing> get box {
    return db.store.box<D2Sharing>();
  }

  D2SharingRepository(this.db);

  Future<List<D2Sharing>> saveOffline(List<Map<String, dynamic>> json) async {
    List<D2Sharing> entities = json
        .map<D2Sharing>(
            (map) => D2Sharing.fromMap(map['sharing'], db: db, id: map['id']))
        .toList();
    return box.putAndGetManyAsync(entities);
  }

  D2Sharing? getByUid(String uid) {
    return box.query(D2Sharing_.uid.equals(uid)).build().findFirst();
  }

  List<D2UserGroupSharing> getUserGroups(D2Sharing sharing) {
    return userGroupBox
        .query(D2UserGroupSharing_.sharing.equals(sharing.id))
        .build()
        .find();
  }

  List<D2UserSharing> getUsers(D2Sharing sharing) {
    return userBox
        .query(D2UserSharing_.sharing.equals(sharing.id))
        .build()
        .find();
  }
}
