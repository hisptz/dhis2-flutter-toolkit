import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/objectbox.g.dart';

import 'base.dart';

class D2ProgramSectionRepository extends BaseMetaRepository<D2ProgramSection> {
  D2ProgramSectionRepository(super.db);

  @override
  D2ProgramSection? getByUid(String uid) {
    Query<D2ProgramSection> query =
        box.query(D2ProgramSection_.uid.equals(uid)).build();
    return query.findFirst();
  }

  @override
  D2ProgramSection mapper(Map<String, dynamic> json) {
    return D2ProgramSection.fromMap(db, json);
  }

  @override
  Future<List<D2ProgramSection>> saveOffline(List<Map<String, dynamic>> json) {
    //We need to delete existing sections for the program in order to record them again
    String programUid = json.first["program"]["id"] as String;
    D2Program? program = D2ProgramRepository(db).getByUid(programUid);

    if (program != null) {
      List<int> sectionIds = box
          .query(D2ProgramSection_.program.equals(program.id))
          .build()
          .findIds();

      if (sectionIds.isNotEmpty) {
        box.removeMany(sectionIds);
      }
    }

    return super.saveOffline(json);
  }
}
