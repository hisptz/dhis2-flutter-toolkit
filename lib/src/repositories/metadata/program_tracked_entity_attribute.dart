
import '../../../objectbox.g.dart';

import '../../models/metadata/program_tracked_entity_attribute.dart';
import 'base.dart';

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

  @override
  D2ProgramTrackedEntityAttribute mapper(Map<String, dynamic> json) {
    return D2ProgramTrackedEntityAttribute.fromMap(db, json);
  }
}
