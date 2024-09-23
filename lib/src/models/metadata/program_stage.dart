import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/program.dart';
import '../../repositories/metadata/program_stage.dart';
import '../data/event.dart';
import 'base.dart';
import 'entry.dart';

@Entity()
class D2ProgramStage extends D2MetaResource {
  @override
  int id = 0;
  DateTime created;

  DateTime lastUpdated;

  @override
  @Unique()
  String uid;
  String name;
  String? description;
  int? sortOrder;
  String? validationStrategy;
  String? featureType;
  String? reportDateToUse;
  bool repeatable;
  String? executionDateLabel;
  String? eventLabel;
  String? programStageLabel;

  final program = ToOne<D2Program>();

  final sharing = ToOne<D2Sharing>();

  @Backlink("programStage")
  final programStageDataElements = ToMany<D2ProgramStageDataElement>();

  @Backlink("programStage")
  final programStageSections = ToMany<D2ProgramStageSection>();

  @Backlink()
  final events = ToMany<D2Event>();

  D2ProgramStage(
      this.created,
      this.displayName,
      this.id,
      this.lastUpdated,
      this.uid,
      this.name,
      this.sortOrder,
      this.validationStrategy,
      this.reportDateToUse,
      this.featureType,
      this.description,
      this.repeatable);

  D2ProgramStage.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json["created"] ?? json["createdAt"]),
        lastUpdated = DateTime.parse(json["lastUpdated"] ?? json["updatedAt"]),
        uid = json["id"],
        name = json["name"],
        displayName = json["displayName"],
        sortOrder = json["sortOrder"],
        validationStrategy = json["validationStrategy"],
        reportDateToUse = json["reportDateToUse"],
        featureType = json["featureType"],
        eventLabel = json["eventLabel"],
        executionDateLabel = json["executionDateLabel"],
        programStageLabel = json["programStageLabel"],
        repeatable = json["repeatable"] ?? false,
        description = json["description"] {
    id = D2ProgramStageRepository(db).getIdByUid(json["id"]) ?? 0;
    program.target =
        D2ProgramRepository(db).getByUid(json["program"]?["id"] ?? "");
  }

  String? displayName;
}
