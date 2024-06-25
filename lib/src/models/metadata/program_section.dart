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

/// This class represents a program section in the DHIS2 system.
class D2ProgramSection extends D2MetaResource {
  @override
  int id = 0;

  /// The creation date of the program section.
  DateTime created;

  /// The last updated date of the program section.
  DateTime lastUpdated;

  /// Unique identifier (UID) for the program section.
  @override
  @Unique()
  String uid;

  /// The sort order of the program section.
  int sortOrder;

  /// The name of the program section.
  String name;

  /// The program to which this section belongs.
  final program = ToOne<D2Program>();

  /// The tracked entity attributes associated with this program section.
  @Backlink("programSection")
  final programSectionTrackedEntityAttributes =
      ToMany<D2ProgramSectionTrackedEntityAttribute>();

  /// Constructs a [D2ProgramSection] instance.
  ///
  /// Parameters:
  /// - [created] The creation date.
  /// - [lastUpdated] The last updated date.
  /// - [uid] The unique identifier.
  /// - [name] The name of the program section.
  /// - [sortOrder] The sort order of the program section.
  D2ProgramSection(
      {required this.created,
      required this.lastUpdated,
      required this.uid,
      required this.name,
      required this.sortOrder});

  /// Constructs a [D2ProgramSection] instance from a JSON object [json].
  ///
  /// - [db] The [D2ObjectBox] instance used for repository operations.
  /// - [json] The JSON object containing the program section data.
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

  /// The display name of the program section.
  @override
  String? displayName;
}
