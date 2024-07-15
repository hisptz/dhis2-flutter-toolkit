import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/models/metadata/user_group_sharing.dart';
import 'package:dhis2_flutter_toolkit/src/models/metadata/user_sharing.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class D2Sharing {
  int id = 0;

  @Unique()
  late String uid;

  String owner;
  bool external;
  String public;

  final program = ToOne<D2Program>();
  final programStage = ToOne<D2ProgramStage>();
  final dataSet = ToOne<D2DataSet>();

  @Backlink('sharing')
  List<D2UserSharing> users = ToMany<D2UserSharing>();

  @Backlink('sharing')
  List<D2UserGroupSharing> userGroups = ToMany<D2UserGroupSharing>();

  D2Sharing(this.id, this.uid, this.owner, this.external, this.public);

  @override
  toString() {
    return uid;
  }

  D2Sharing.fromMap(Map json, {required String id, required D2ObjectBox db})
      : owner = json['owner'],
        external = json['external'],
        public = json['public'],
        uid = id {
    this.id = D2SharingRepository(db).getByUid(uid)?.id ?? 0;
    program.target = D2ProgramRepository(db).getByUid(uid);
    programStage.target = D2ProgramStageRepository(db).getByUid(uid);
    dataSet.target = D2DataSetRepository(db).getByUid(uid);

    Map userGroupObjects = json['userGroups'];
    List<D2UserGroupSharing> userGroupsData = userGroupObjects.keys
        .map((key) => D2UserGroupSharing.fromMap(userGroupObjects[key], this))
        .toList();
    db.store.box<D2UserGroupSharing>().putMany(userGroupsData);
    userGroups.addAll(userGroupsData);
    Map usersObject = json['users'];
    List<D2UserSharing> userData = usersObject.keys
        .map((key) => D2UserSharing.fromMap(usersObject[key], this))
        .toList();
    db.store.box<D2UserSharing>().putMany(userData);
    users.addAll(userData);
  }
}
