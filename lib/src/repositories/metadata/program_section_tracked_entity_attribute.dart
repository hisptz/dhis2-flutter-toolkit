import 'package:dhis2_flutter_toolkit/src/models/metadata/program_section_tracked_entity_attribute.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/metadata/base.dart';

import '../../../objectbox.g.dart';

class D2ProgramSectionTrackedEntityAttributeRepository
    extends BaseMetaRepository<D2ProgramSectionTrackedEntityAttribute> {
  D2ProgramSectionTrackedEntityAttributeRepository(super.db);

  @override
  D2ProgramSectionTrackedEntityAttribute? getByUid(String uid) {
    return box
        .query(D2ProgramSectionTrackedEntityAttribute_.uid.equals(uid))
        .build()
        .findFirst();
  }

  @override
  D2ProgramSectionTrackedEntityAttribute mapper(Map<String, dynamic> json) {
    return D2ProgramSectionTrackedEntityAttribute(
        json["sortOrder"], json["id"]);
  }
}
