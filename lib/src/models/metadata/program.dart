import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/models/metadata/program_rule.dart';
import 'package:objectbox/objectbox.dart';

import 'base.dart';

@Entity()
class D2Program extends D2MetaResource {
  @override
  int id = 0;
  DateTime created;

  DateTime lastUpdated;

  @override
  @Unique()
  String uid;

  String name;
  String shortName;
  String accessLevel;

  String? featureType;

  String programType;
  bool? onlyEnrollOnce;

  bool? selectEnrollmentDatesInFuture;

  final organisationUnits = ToMany<D2OrgUnit>();

  @Backlink("program")
  final programStages = ToMany<D2ProgramStage>();

  @Backlink("program")
  final programRules = ToMany<D2ProgramRule>();

  @Backlink("program")
  final programRuleVariables = ToMany<D2ProgramRuleVariable>();

  @Backlink("program")
  final programSections = ToMany<D2ProgramSection>();

  final trackedEntityType = ToOne<D2TrackedEntityType>();

  @Backlink("program")
  final programTrackedEntityAttributes =
      ToMany<D2ProgramTrackedEntityAttribute>();

  @Backlink()
  final events = ToMany<D2Event>();

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

  String? displayName;
}
