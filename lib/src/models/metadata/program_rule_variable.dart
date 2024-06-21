import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/data_element.dart';
import '../../repositories/metadata/program.dart';
import '../../repositories/metadata/program_rule_variable.dart';
import '../../repositories/metadata/program_stage.dart';
import '../../repositories/metadata/tracked_entity_attribute.dart';
import 'base.dart';
import 'data_element.dart';
import 'program.dart';
import 'program_stage.dart';
import 'tracked_entity_attribute.dart';

@Entity()

/// This class represents a program rule variable within the DHIS2 system.
///
/// This class extends [D2MetaResource] and encapsulates attributes related to program rule variables,
/// such as name, source type, value type, and associations with tracked entity attributes, data elements,
/// program stages, and programs.
class D2ProgramRuleVariable extends D2MetaResource {
  @override
  int id = 0;

  /// Date and time when the program rule variable was created.
  @override
  DateTime created;

  /// Date and time when the program rule variable was last updated.
  @override
  DateTime lastUpdated;

  /// Unique identifier of the program rule variable.
  @override
  @Unique()
  String uid;

  /// Name of the program rule variable.
  String name;

  /// Source type of the program rule variable.
  String programRuleVariableSourceType;

  /// Value type of the program rule variable.
  String valueType;

  /// Indicates whether to use code for the option set.
  bool useCodeForOptionSet;

  /// Association with a tracked entity attribute.
  final trackedEntityAttribute = ToOne<D2TrackedEntityAttribute>();

  /// Association with a data element.
  final dataElement = ToOne<D2DataElement>();

  /// Association with a program stage.
  final programStage = ToOne<D2ProgramStage>();

  /// Association with a program.
  final program = ToOne<D2Program>();

  /// Constructs a [D2ProgramRuleVariable].
  ///
  /// - [displayName]: Display name of the program rule variable.
  /// - [id]: Identifier of the program rule variable.
  /// - [created]: Date and time when the program rule variable was created.
  /// - [lastUpdated]: Date and time when the program rule variable was last updated.
  /// - [uid]: Unique identifier of the program rule variable.
  /// - [name]: Name of the program rule variable.
  /// - [programRuleVariableSourceType]: Source type of the program rule variable.
  /// - [valueType]: Value type of the program rule variable.
  /// - [useCodeForOptionSet]: Indicates whether to use code for the option set.
  D2ProgramRuleVariable(
      this.displayName,
      this.id,
      this.created,
      this.lastUpdated,
      this.uid,
      this.name,
      this.programRuleVariableSourceType,
      this.valueType,
      this.useCodeForOptionSet);

  /// Constructs a [D2ProgramRuleVariable] from a JSON map [json].
  ///
  /// Parameters:
  /// - [db]: The [D2ObjectBox] instance used for repository operations.
  /// - [json]: JSON [Map] containing the program rule variable data.
  ///
  /// This constructor initializes the program rule variable attributes from the JSON map,
  /// including associations with tracked entity attributes, data elements, program stages,
  /// and programs.
  D2ProgramRuleVariable.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"]),
        uid = json["id"],
        name = json["name"],
        displayName = json["displayName"],
        programRuleVariableSourceType = json["programRuleVariableSourceType"],
        valueType = json["valueType"],
        useCodeForOptionSet = json["useCodeForOptionSet"] {
    id = D2ProgramRuleVariableRepository(db).getIdByUid(json["id"]) ?? 0;

    if (json["trackedEntityAttribute"] != null) {
      trackedEntityAttribute.target = D2TrackedEntityAttributeRepository(db)
          .getByUid(json["trackedEntityAttribute"]["id"]);
    }

    if (json["dataElement"] != null) {
      dataElement.target =
          D2DataElementRepository(db).getByUid(json["dataElement"]["id"]);
    }
    if (json["programStage"] != null) {
      programStage.target =
          D2ProgramStageRepository(db).getByUid(json["programStage"]["id"]);
    }
    program.target = D2ProgramRepository(db).getByUid(json["program"]["id"]);
  }

  /// The display name of the program rule variable.
  @override
  String? displayName;
}
