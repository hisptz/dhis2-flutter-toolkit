import 'package:dhis2_flutter_toolkit/src/repositories/data/program_owner.dart';
import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import '../../repositories/data/entry.dart';
import '../../repositories/metadata/entry.dart';
import '../metadata/entry.dart';
import 'entry.dart';

@Entity()
class D2ProgramOwner extends D2DataResource {
  int id = 0;

  String uid;

  final trackedEntity = ToOne<D2TrackedEntity>();
  final program = ToOne<D2Program>();
  final orgUnit = ToOne<D2OrgUnit>();

  D2ProgramOwner.fromMap(D2ObjectBox db, Map json)
      : uid = '${json['trackedEntity']}-${json['program']}',
        createdAt = DateTime.now(),
        updatedAt = DateTime.now() {
    id = D2ProgramOwnerRepository(db).getIdByUid(uid) ?? 0;
    trackedEntity.target =
        D2TrackedEntityRepository(db).getByUid(json["trackedEntity"]);
    program.target = D2ProgramRepository(db).getByUid(json["program"]);
    orgUnit.target = D2OrgUnitRepository(db).getByUid(json["orgUnit"]);
  }

  D2ProgramOwner(this.id, this.uid, this.createdAt, this.updatedAt);

  toMap({D2ObjectBox? db}) {
    return {
      "trackedEntity": trackedEntity.target!.uid,
      "program": program.target!.uid,
      "orgUnit": orgUnit.target!.uid,
    };
  }

  @override
  DateTime createdAt;

  @override
  DateTime updatedAt;
}
