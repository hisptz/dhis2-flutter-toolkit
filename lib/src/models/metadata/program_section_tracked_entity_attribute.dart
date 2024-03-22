import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/models/metadata/base.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/metadata/program_section_tracked_entity_attribute.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class D2ProgramSectionTrackedEntityAttribute extends D2MetaResource {
  @override
  int id = 0;

  @override
  @Unique()
  String uid;

  int sortOrder;

  D2ProgramSectionTrackedEntityAttribute(this.sortOrder, this.uid);

  final trackedEntityAttribute = ToOne<D2TrackedEntityAttribute>();
  final programSection = ToOne<D2ProgramSection>();

  D2ProgramSectionTrackedEntityAttribute.fromSection(
      {required D2ObjectBox db,
      required D2ProgramSection section,
      required D2TrackedEntityAttribute attribute,
      required this.sortOrder})
      : uid = "${section.uid}-${attribute.uid}" {
    Box<D2ProgramSectionTrackedEntityAttribute> box =
        db.store.box<D2ProgramSectionTrackedEntityAttribute>();
    id = D2ProgramSectionTrackedEntityAttributeRepository(db).getIdByUid(uid) ??
        0;
    trackedEntityAttribute.target = attribute;
    programSection.target = section;
  }
}
