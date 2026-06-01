import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/data_set_section_data_element.dart';
import 'base.dart';
import 'data_element.dart';
import 'data_set_section.dart';

@Entity()
class D2DataSetSectionDataElement extends D2MetaResource {
  int id = 0;

  @Unique()
  @override
  String uid;

  int sortOrder;

  final dataElement = ToOne<D2DataElement>();
  final dataSetSection = ToOne<D2DataSetSection>();

  D2DataSetSectionDataElement(this.uid, this.sortOrder);

  D2DataSetSectionDataElement.fromSection({
    required D2ObjectBox db,
    required D2DataSetSection section,
    required D2DataElement dataElement,
    required this.sortOrder,
  }) : uid = '${section.uid}-${dataElement.uid}' {
    id = D2DataSetSectionDataElementRepository(db).getIdByUid(uid) ?? 0;
    this.dataElement.target = dataElement;
    dataSetSection.target = section;
  }
}
