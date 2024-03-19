import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/data_element.dart';
import '../../repositories/metadata/program_stage.dart';
import '../../repositories/metadata/program_stage_data_element.dart';
import 'base.dart';
import 'data_element.dart';
import 'program_stage.dart';

@Entity()
class D2ProgramStageDataElement extends D2MetaResource {
  @override
  DateTime created;

  @override
  int id = 0;

  @override
  DateTime lastUpdated;

  @override
  String uid;

  bool compulsory;
  int? sortOrder;
  bool allowFutureDate;
  bool renderOptionsAsRadio;

  final programStage = ToOne<D2ProgramStage>();
  final dataElement = ToOne<D2DataElement>();

  D2ProgramStageDataElement(
      this.created,
      this.id,
      this.lastUpdated,
      this.uid,
      this.compulsory,
      this.sortOrder,
      this.allowFutureDate,
      this.displayName,
      this.renderOptionsAsRadio);

  D2ProgramStageDataElement.fromMap(D2ObjectBox db, Map json)
      : uid = json["id"],
        created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"]),
        compulsory = json["compulsory"],
        sortOrder = json["sortOrder"],
        allowFutureDate = json["allowFutureDate"],
        renderOptionsAsRadio = json["renderOptionsAsRadio"] {
    id = D2ProgramStageDataElementRepository(db).getIdByUid(json["id"]) ?? 0;
    dataElement.target =
        D2DataElementRepository(db).getByUid(json["dataElement"]["id"]);
    programStage.target =
        D2ProgramStageRepository(db).getByUid(json["programStage"]["id"]);
  }

  @override
  String? displayName;
}
