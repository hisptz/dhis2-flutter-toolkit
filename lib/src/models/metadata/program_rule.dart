import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/program_rule.dart';
import 'base.dart';

@Entity()
class D2ProgramRule extends D2MetaResource {
  @override
  int id = 0;
  DateTime created;

  DateTime lastUpdated;

  @override
  String uid;

  String name;
  String? description;
  String condition;
  int? priority;

  final program = ToOne<D2Program>();
  final programStage = ToOne<D2ProgramStage>();

  @Backlink("programRule")
  final programRuleActions = ToMany<D2ProgramRuleAction>();

  D2ProgramRule(
    this.id,
    this.displayName,
    this.created,
    this.lastUpdated,
    this.uid,
    this.name,
    this.description,
    this.condition,
    this.priority,
  );

  D2ProgramRule.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json["created"] ?? json["createdAt"]),
        lastUpdated = DateTime.parse(json["lastUpdated"] ?? json["updatedAt"]),
        uid = json["id"],
        name = json["name"],
        description = json["description"],
        displayName = json["displayName"],
        priority = json["priority"],
        condition = json["condition"] ?? "" {
    id = D2ProgramRuleRepository(db).getIdByUid(json["id"]) ?? 0;

    program.target = D2ProgramRepository(db).getByUid(json["program"]["id"]);
    if (json["programStage"] != null) {
      programStage.target =
          D2ProgramStageRepository(db).getByUid(json["programStage"]["id"]);
    }
  }

  String? displayName;
}
