import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import '../../repositories/metadata/data_element.dart';
import '../../repositories/metadata/option.dart';
import '../../repositories/metadata/option_group.dart';
import '../../repositories/metadata/program_rule.dart';
import '../../repositories/metadata/program_rule_action.dart';
import '../../repositories/metadata/program_section.dart';
import '../../repositories/metadata/program_stage_section.dart';
import '../../repositories/metadata/tracked_entity_attribute.dart';
import 'base.dart';
import 'data_element.dart';
import 'option.dart';
import 'option_group.dart';
import 'program_rule.dart';
import 'program_section.dart';
import 'program_stage_section.dart';
import 'tracked_entity_attribute.dart';

@Entity()
class D2ProgramRuleAction extends D2MetaResource {
  @override
  int id = 0;
  DateTime created;
  DateTime lastUpdated;

  @override
  @Unique()
  String uid;

  String programRuleActionType;
  String? content;
  String? data;
  String? location;

  final programRule = ToOne<D2ProgramRule>();
  final dataElement = ToOne<D2DataElement>();
  final programStageSection = ToOne<D2ProgramStageSection>();
  final programSection = ToOne<D2ProgramSection>();
  final trackedEntityAttribute = ToOne<D2TrackedEntityAttribute>();
  final option = ToOne<D2Option>();
  final optionGroup = ToOne<D2OptionGroup>();

  D2ProgramRuleAction(
      this.id,
      this.displayName,
      this.created,
      this.lastUpdated,
      this.uid,
      this.programRuleActionType,
      this.content,
      this.data,
      this.location);

  D2ProgramRuleAction.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json["created"] ?? json["createdAt"]),
        lastUpdated = DateTime.parse(json["lastUpdated"] ?? json["updatedAt"]),
        uid = json["id"],
        programRuleActionType = json["programRuleActionType"],
        content = json["content"],
        data = json["data"],
        displayName = json["displayName"],
        location = json["location"] {
    id = D2ProgramRuleActionRepository(db).getIdByUid(json["id"]) ?? 0;

    programRule.target =
        D2ProgramRuleRepository(db).getByUid(json["programRule"]["id"]);

    if (json["dataElement"] != null) {
      dataElement.target =
          D2DataElementRepository(db).getByUid(json["dataElement"]["id"]);
    }
    if (json["trackedEntityAttribute"] != null) {
      trackedEntityAttribute.target = D2TrackedEntityAttributeRepository(db)
          .getByUid(json["trackedEntityAttribute"]["id"]);
    }
    if (json["programStageSection"] != null) {
      programStageSection.target = D2ProgramStageSectionRepository(db)
          .getByUid(json["programStageSection"]["id"]);
    }
    if (json["programSection"] != null) {
      programSection.target =
          D2ProgramSectionRepository(db).getByUid(json["programSection"]["id"]);
    }
    if (json["option"] != null) {
      option.target = D2OptionRepository(db).getByUid(json["option"]["id"]);
    }
    if (json["optionGroup"] != null) {
      optionGroup.target =
          D2OptionGroupRepository(db).getByUid(json["optionGroup"]["id"]);
    }
  }

  @override
  String? displayName;
}
