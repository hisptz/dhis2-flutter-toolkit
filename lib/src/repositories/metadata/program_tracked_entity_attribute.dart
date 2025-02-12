import '../../../objectbox.g.dart';
import '../../models/metadata/entry.dart';
import 'base.dart';
import 'entry.dart';

class D2ProgramTrackedEntityAttributeRepository
    extends BaseMetaRepository<D2ProgramTrackedEntityAttribute> {
  D2ProgramTrackedEntityAttributeRepository(super.db);

  @override
  D2ProgramTrackedEntityAttribute? getByUid(String uid) {
    Query<D2ProgramTrackedEntityAttribute> query =
        box.query(D2ProgramTrackedEntityAttribute_.uid.equals(uid)).build();
    return query.findFirst();
  }

  D2ProgramTrackedEntityAttributeRepository byProgram(int programId) {
    queryConditions =
        D2ProgramTrackedEntityAttribute_.program.equals(programId);
    return this;
  }

  Future<void> deleteByProgram(String programId) async {
    D2Program? program = D2ProgramRepository(db).getByUid(programId);
    await box
        .query(D2ProgramTrackedEntityAttribute_.program.equals(program!.id))
        .build()
        .removeAsync();
  }

  @override
  D2ProgramTrackedEntityAttribute mapper(Map<String, dynamic> json) {
    return D2ProgramTrackedEntityAttribute.fromMap(db, json);
  }
}
