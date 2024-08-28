import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/objectbox.g.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/metadata/program_section_tracked_entity_attribute.dart';

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
  Future<List<D2ProgramSection>> saveOffline(
    List<Map<String, dynamic>> json,
  ) async {
    //We need to delete existing sections for the program in order to record them again
    String programUid = json.first["program"]["id"] as String;
    D2Program? program = D2ProgramRepository(db).getByUid(programUid);

    if (program != null) {
      List<D2ProgramSection> programSections = await box
          .query(D2ProgramSection_.program.equals(program.id))
          .build()
          .findAsync();

      List<int> sectionIds =
          programSections.map((section) => section.id).toList();

      if (programSections.isNotEmpty) {
        List<int> programSectionAttributes = [];
        for (D2ProgramSection section in programSections) {
          programSectionAttributes.addAll(section
              .programSectionTrackedEntityAttributes
              .map((element) => element.id));
        }
        await D2ProgramSectionTrackedEntityAttributeRepository(db)
            .box
            .removeManyAsync(programSectionAttributes);
        await box.removeManyAsync(sectionIds);
      }
    }

    return super.saveOffline(json);
  }
}
