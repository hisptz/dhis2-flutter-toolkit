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

/// This class represents an action associated with a program rule in the DHIS2 system.
///
/// This class provides details about a specific action that can be taken as part of
/// a program rule, such as showing an error message, assigning a value, hiding a field, etc.
class D2ProgramRuleAction extends D2MetaResource {
  /// The unique identifier of the program rule action.
  @override
  int id = 0;

  /// The date and time when the program rule action was created.
  DateTime created;

  /// The date and time when the program rule action was last updated.
  DateTime lastUpdated;

  /// The unique identifier string of the program rule action.
  @override
  @Unique()
  String uid;

  /// The type of action to be taken.
  String programRuleActionType;

  /// The content associated with the action, if any.
  String? content;

  /// The data associated with the action, if any.
  String? data;

  /// The location associated with the action, if any.
  String? location;

  /// Reference to the associated program rule.
  final programRule = ToOne<D2ProgramRule>();

  /// Reference to the associated data element, if any.
  final dataElement = ToOne<D2DataElement>();

  /// Reference to the associated program stage section, if any.
  final programStageSection = ToOne<D2ProgramStageSection>();

  /// Reference to the associated program section, if any.
  final programSection = ToOne<D2ProgramSection>();

  /// Reference to the associated tracked entity attribute, if any.
  final trackedEntityAttribute = ToOne<D2TrackedEntityAttribute>();

  /// Reference to the associated option, if any.
  final option = ToOne<D2Option>();

  /// Reference to the associated option group, if any.
  final optionGroup = ToOne<D2OptionGroup>();

  /// Constructs a [D2ProgramRuleAction] with the provided details.
  ///
  /// - [id] The unique identifier of the program rule action.
  /// - [displayName] The display name of the program rule action.
  /// - [created] The creation date of the program rule action.
  /// - [lastUpdated] The last updated date of the program rule action.
  /// - [uid] The unique identifier string of the program rule action.
  /// - [programRuleActionType] The type of action to be taken.
  /// - [content] The content associated with the action, if any.
  /// - [data] The data associated with the action, if any.
  /// - [location] The location associated with the action, if any.
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

  /// Constructs a [D2ProgramRuleAction] from a JSON map [json].
  ///
  /// - [db] The database instance.
  /// - [json] The JSON map containing program rule action data.
  D2ProgramRuleAction.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"]),
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

  /// The display name of the program rule action.
  @override
  String? displayName;
}
