import 'package:dhis2_flutter_toolkit/src/models/metadata/program.dart';

import '../../../objectbox.g.dart';
import '../../models/data/entry.dart';
import 'entry.dart';

class D2ProgramOwnerRepository
    extends D2BaseTrackerDataRepository<D2ProgramOwner> {
  D2ProgramOwnerRepository(super.db);

  @override
  D2ProgramOwner? getByUid(String uid) {
    return box.query(D2ProgramOwner_.uid.equals(uid)).build().findFirst();
  }

  @override
  D2ProgramOwner mapper(Map<String, dynamic> json) {
    return D2ProgramOwner.fromMap(db, json);
  }

  @override
  D2BaseTrackerDataRepository<D2ProgramOwner> setProgram(D2Program program) {
    return this;
  }

  List<D2ProgramOwner> getByTrackedEntity(D2TrackedEntity trackedEntity) {
    return box
        .query(D2ProgramOwner_.trackedEntity.equals(trackedEntity.id))
        .build()
        .find();
  }
}
