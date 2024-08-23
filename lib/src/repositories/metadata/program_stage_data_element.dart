import '../../../objectbox.g.dart';

import '../../models/metadata/program_stage_data_element.dart';
import 'base.dart';

class D2ProgramStageDataElementRepository
    extends BaseMetaRepository<D2ProgramStageDataElement> {
  D2ProgramStageDataElementRepository(super.db);

  @override
  D2ProgramStageDataElement? getByUid(String uid) {
    Query<D2ProgramStageDataElement> query =
        box.query(D2ProgramStageDataElement_.uid.equals(uid)).build();
    return query.findFirst();
  }

  @override
  D2ProgramStageDataElement mapper(Map<String, dynamic> json) {
    return D2ProgramStageDataElement.fromMap(db, json);
  }
}
