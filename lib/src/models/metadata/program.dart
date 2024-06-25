import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import '../../repositories/metadata/org_unit.dart';
import '../../repositories/metadata/program.dart';
import '../../repositories/metadata/tracked_entity_type.dart';
import 'base.dart';
import 'org_unit.dart';
import 'program_rule.dart';
import 'program_rule_variable.dart';
import 'program_section.dart';
import 'program_stage.dart';
import 'program_tracked_entity_attribute.dart';
import 'tracked_entity_type.dart';

@Entity()

/// This class represents a program in the DHIS2 system with various utility methods.
class D2Program extends D2MetaResource {
  @override
  int id = 0;

  /// The creation date of the program.
  DateTime created;

  /// The last updated date of the program.
  DateTime lastUpdated;

  @override
  @Unique()
  String uid;

  /// The name of the program.
  String name;

  /// The short name of the program.
  String shortName;

  /// The access level of the program.
  String accessLevel;

  /// The feature type of the program.
  String? featureType;

  /// The type of the program.
  String programType;

  /// Whether the program can only be enrolled once.
  bool? onlyEnrollOnce;

  /// Whether enrollment dates can be selected in the future.
  bool? selectEnrollmentDatesInFuture;

  /// The organisation units associated with the program.
  final organisationUnits = ToMany<D2OrgUnit>();

  @Backlink("program")
  final programStages = ToMany<D2ProgramStage>();

  @Backlink("program")
  final programRules = ToMany<D2ProgramRule>();

  @Backlink("program")
  final programRuleVariables = ToMany<D2ProgramRuleVariable>();

  @Backlink("program")
  final programSections = ToMany<D2ProgramSection>();

  /// The tracked entity type associated with the program.
  final trackedEntityType = ToOne<D2TrackedEntityType>();

  @Backlink("program")
  final programTrackedEntityAttributes =
      ToMany<D2ProgramTrackedEntityAttribute>();

  /// Constructs a [D2Program].
  ///
  /// - [created] The creation date of the program.
  /// - [lastUpdated] The last updated date of the program.
  /// - [uid] The unique identifier of the program.
  /// - [accessLevel] The access level of the program.
  /// - [name] The name of the program.
  /// - [shortName] The short name of the program.
  /// - [programType] The type of the program.
  /// - [onlyEnrollOnce] Whether the program can only be enrolled once.
  /// - [displayName] The display name of the program.
  /// - [featureType] The feature type of the program.
  D2Program(
      this.created,
      this.lastUpdated,
      this.uid,
      this.accessLevel,
      this.name,
      this.shortName,
      this.programType,
      this.onlyEnrollOnce,
      this.displayName,
      this.featureType);

  /// Constructs a [D2Program] from a JSON map [json].
  ///
  /// - [db] The database instance.
  /// - [json] The JSON map containing program data.
  D2Program.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"]),
        uid = json["id"],
        displayName = json["displayName"],
        accessLevel = json["accessLevel"],
        name = json["name"],
        shortName = json["shortName"],
        programType = json["programType"],
        featureType = json["featureType"] {
    id = D2ProgramRepository(db).getIdByUid(json["id"]) ?? 0;

    if (json["trackedEntityType"] != null) {
      trackedEntityType.target = D2TrackedEntityTypeRepository(db)
          .getByUid(json["trackedEntityType"]["id"]);
    }

    List<D2OrgUnit?> programOrgUnits = json["organisationUnits"]
        .cast<Map>()
        .map<D2OrgUnit?>(
            (Map orgUnit) => D2OrgUnitRepository(db).getByUid(orgUnit["id"]))
        .toList();

    List<D2OrgUnit> orgUnits = programOrgUnits
        .where((D2OrgUnit? element) => element != null)
        .toList()
        .cast<D2OrgUnit>();
    organisationUnits.addAll(orgUnits);
  }

  /// The display name of the program.
  String? displayName;
}
