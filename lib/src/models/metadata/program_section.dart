import 'package:collection/collection.dart';
import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:dhis2_flutter_toolkit/src/models/metadata/program_section_tracked_entity_attribute.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/program.dart';
import '../../repositories/metadata/program_section.dart';
import '../../repositories/metadata/tracked_entity_attribute.dart';
import 'base.dart';
import 'program.dart';
import 'tracked_entity_attribute.dart';

@Entity()
class D2ProgramSection extends D2MetaResource {
  @override
  int id = 0;
  DateTime created;

  DateTime lastUpdated;

  @override
  @Unique()
  String uid;
  int sortOrder;
  String name;

  final program = ToOne<D2Program>();
  @Backlink("programSection")
  final programSectionTrackedEntityAttributes =
      ToMany<D2ProgramSectionTrackedEntityAttribute>();

  D2ProgramSection(
      {required this.created,
      required this.lastUpdated,
      required this.uid,
      required this.name,
      required this.sortOrder});

  D2ProgramSection.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"]),
        uid = json["id"],
        name = json["name"],
        sortOrder = json["sortOrder"] {
    id = D2ProgramSectionRepository(db).getIdByUid(json["id"]) ?? 0;
    List<D2TrackedEntityAttribute?> tei = json["trackedEntityAttributes"]
        .cast<Map>()
        .map<D2TrackedEntityAttribute?>((Map tea) =>
            D2TrackedEntityAttributeRepository(db).getByUid(tea["id"]))
        .toList();

    List<D2ProgramSectionTrackedEntityAttribute> actualTea = tei
        .where((element) => element != null)
        .toList()
        .cast<D2TrackedEntityAttribute>()
        .mapIndexed<D2ProgramSectionTrackedEntityAttribute>(
            (int index, attribute) =>
                D2ProgramSectionTrackedEntityAttribute.fromSection(
                    section: this,
                    attribute: attribute,
                    sortOrder: index,
                    db: db))
        .toList();
    programSectionTrackedEntityAttributes.addAll(actualTea);
    program.target = D2ProgramRepository(db).getByUid(json["program"]["id"]);
  }

  @override
  String? displayName;
}
