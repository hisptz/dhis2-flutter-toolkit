import 'package:dhis2_flutter_toolkit/objectbox.dart';

import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/program.dart';
import '../../repositories/metadata/program_rule.dart';
import 'base.dart';
import 'program.dart';
import 'program_rule_action.dart';

@Entity()
class D2ProgramRule extends D2MetaResource {
  @override
  int id = 0;
  @override
  DateTime created;

  @override
  DateTime lastUpdated;

  @override
  String uid;

  String name;
  String? description;
  String? condition;
  int? priority;

  var program = ToOne<D2Program>();

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
      : created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"]),
        uid = json["id"],
        name = json["name"],
        description = json["description"],
        displayName = json["displayName"],
        priority = json["priority"],
        condition = json["condition"] {
    id = D2ProgramRuleRepository(db).getIdByUid(json["id"]) ?? 0;

    program.target = D2ProgramRepository(db).getByUid(json["program"]["id"]);
  }

  @override
  String? displayName;
}
