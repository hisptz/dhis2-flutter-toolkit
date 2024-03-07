
import 'package:dhis2_flutter_toolkit/objectbox.dart';
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
  @override
  DateTime created;

  @override
  DateTime lastUpdated;

  @override
  @Unique()
  String uid;
  String name;
  int sortOrder;

  final programStage = ToOne<D2ProgramStage>();

  final dataElements = ToMany<D2DataElement>();

  D2ProgramStageSection(
      this.created, this.lastUpdated, this.uid, this.name, this.sortOrder);

  D2ProgramStageSection.fromMap(ObjectBox db, Map json)
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

    List<D2DataElement> des = dataElementObjects
        .where((D2DataElement? element) => element != null)
        .toList()
        .cast<D2DataElement>();
    dataElements.addAll(des);
    programStage.target =
        D2ProgramStageRepository(db).getByUid(json["programStage"]["id"]);
  }

  @override
  String? displayName;
}
