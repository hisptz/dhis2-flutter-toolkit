import '../../../objectbox.g.dart';

import '../../models/metadata/program_stage.dart';
import 'base.dart';

class D2ProgramStageRepository extends BaseMetaRepository<D2ProgramStage> {
  D2ProgramStageRepository(super.db);

  @override
  D2ProgramStage? getByUid(String uid) {
    Query<D2ProgramStage> query =
        box.query(D2ProgramStage_.uid.equals(uid)).build();
    return query.findFirst();
  }

  @override
  D2ProgramStage mapper(Map<String, dynamic> json) {
    return D2ProgramStage.fromMap(db, json);
  }

  D2ProgramStageRepository byProgram(int programId) {
    queryConditions = D2ProgramStage_.program.equals(programId);
    return this;
  }
}
