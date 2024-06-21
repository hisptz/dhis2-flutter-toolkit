import 'package:collection/collection.dart';
import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:dhis2_flutter_toolkit/src/models/metadata/program_stage_section_data_element.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/data_element.dart';
import '../../repositories/metadata/program_stage.dart';
import '../../repositories/metadata/program_stage_section.dart';
import 'base.dart';
import 'data_element.dart';
import 'program_stage.dart';

@Entity()

/// This class represents a section within a program stage of the DHIS2 system.
class D2ProgramStageSection extends D2MetaResource {
  @override
  int id = 0;

  /// The date and time when the program stage section was created.
  DateTime created;

  /// The date and time when the program stage section was last updated.
  DateTime lastUpdated;

  /// The unique identifier of the program stage section.
  @override
  @Unique()
  String uid;

  /// The name of the program stage section.
  String name;

  /// The sort order of the program stage section.
  int sortOrder;

  /// The associated program stage.
  final programStage = ToOne<D2ProgramStage>();

  /// The data elements associated with this program stage section.
  @Backlink("programStageSection")
  final programStageSectionDataElements =
      ToMany<D2ProgramStageSectionDataElement>();

  /// Creates a new instance of [D2ProgramStageSection].
  ///
  /// - [created] is the date and time when the section was created.
  /// - [lastUpdated] is the date and time when the section was last updated.
  /// - [uid] is the unique identifier of the section.
  /// - [name] is the name of the section.
  /// - [sortOrder] is the sort order of the section.
  D2ProgramStageSection(
      this.created, this.lastUpdated, this.uid, this.name, this.sortOrder);

  /// Creates a new instance of [D2ProgramStageSection] from a JSON object [json].
  ///
  /// - [db] is the database instance.
  /// - [json] is the map containing the data to initialize the instance.
  D2ProgramStageSection.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"]),
        uid = json["id"],
        name = json["name"],
        sortOrder = json["sortOrder"] {
    id = D2ProgramStageSectionRepository(db).getIdByUid(json["id"]) ?? 0;
    List<D2DataElement?> dataElementObjects = json["dataElements"]
        .cast<Map>()
        .map<D2DataElement?>(
            (Map de) => D2DataElementRepository(db).getByUid(de["id"]))
        .toList();

    List<D2ProgramStageSectionDataElement> des = dataElementObjects
        .where((D2DataElement? element) => element != null)
        .toList()
        .cast<D2DataElement>()
        .mapIndexed<D2ProgramStageSectionDataElement>((index, dataElement) =>
            D2ProgramStageSectionDataElement.fromSection(
                db: db,
                sortOrder: index,
                section: this,
                dataElement: dataElement))
        .toList();
    programStageSectionDataElements.addAll(des);
    programStage.target =
        D2ProgramStageRepository(db).getByUid(json["programStage"]["id"]);
  }

  /// The display name of the program stage section.
  String? displayName;
}
