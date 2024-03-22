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
class D2ProgramStageSection extends D2MetaResource {
  @override
  int id = 0;
  DateTime created;

  DateTime lastUpdated;

  @override
  @Unique()
  String uid;
  String name;
  int sortOrder;

  final programStage = ToOne<D2ProgramStage>();

  @Backlink("programStageSection")
  final programStageSectionDataElements = ToMany<D2ProgramStageSectionDataElement>();

  D2ProgramStageSection(
      this.created, this.lastUpdated, this.uid, this.name, this.sortOrder);

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

  String? displayName;
}
