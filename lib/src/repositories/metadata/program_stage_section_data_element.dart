import '../../../objectbox.g.dart';
import '../../models/metadata/program_stage_section_data_element.dart';
import 'base.dart';

class D2ProgramStageSectionDataElementRepository
    extends BaseMetaRepository<D2ProgramStageSectionDataElement> {
  D2ProgramStageSectionDataElementRepository(super.db);

  @override
  D2ProgramStageSectionDataElement? getByUid(String uid) {
    return box
        .query(D2ProgramStageSectionDataElement_.uid.equals(uid))
        .build()
        .findFirst();
  }

  @override
  D2ProgramStageSectionDataElement mapper(Map<String, dynamic> json) {
    return D2ProgramStageSectionDataElement(json["sortOrder"], json["id"]);
  }
}
