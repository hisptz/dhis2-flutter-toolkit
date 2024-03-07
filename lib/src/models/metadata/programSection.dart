import 'package:dhis2_flutter_toolkit/objectbox.dart';

import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/program.dart';
import '../../repositories/metadata/programSection.dart';
import '../../repositories/metadata/trackedEntityAttribute.dart';
import 'base.dart';
import 'program.dart';
import 'trackedEntityAttributes.dart';

@Entity()
class D2ProgramSection extends D2MetaResource {
  @override
  int id = 0;
  @override
  DateTime created;

  @override
  DateTime lastUpdated;

  @override
  @Unique()
  String uid;
  int sortOrder;
  String name;

  final program = ToOne<D2Program>();

  final trackedEntityAttributes = ToMany<D2TrackedEntityAttribute>();

  D2ProgramSection(
      {required this.created,
      required this.lastUpdated,
      required this.uid,
      required this.name,
      required this.sortOrder});

  D2ProgramSection.fromMap(ObjectBox db, Map json)
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

    List<D2TrackedEntityAttribute> actualTea = tei
        .where((element) => element != null)
        .toList()
        .cast<D2TrackedEntityAttribute>();
    trackedEntityAttributes.addAll(actualTea);
    program.target = D2ProgramRepository(db).getByUid(json["program"]["id"]);
  }

  @override
  String? displayName;
}
