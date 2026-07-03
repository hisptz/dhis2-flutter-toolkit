import '../../../objectbox.g.dart';
import '../../models/metadata/data_set_section_data_element.dart';
import 'base.dart';

class D2DataSetSectionDataElementRepository
    extends BaseMetaRepository<D2DataSetSectionDataElement> {
  D2DataSetSectionDataElementRepository(super.db);

  @override
  D2DataSetSectionDataElement? getByUid(String uid) {
    return box
        .query(D2DataSetSectionDataElement_.uid.equals(uid))
        .build()
        .findFirst();
  }

  @override
  D2DataSetSectionDataElement mapper(Map<String, dynamic> json) {
    return D2DataSetSectionDataElement(
        json['id'] as String, json['sortOrder'] as int);
  }
}
