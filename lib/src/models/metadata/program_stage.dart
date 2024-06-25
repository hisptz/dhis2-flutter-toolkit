import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/program.dart';
import '../../repositories/metadata/program_stage.dart';
import '../data/event.dart';
import 'base.dart';
import 'program.dart';
import 'program_stage_data_element.dart';
import 'program_stage_section.dart';

@Entity()

/// This class represents a program stage within the DHIS2 system.
class D2ProgramStage extends D2MetaResource {
  @override
  int id = 0;

  /// The date and time when the program stage was created.
  DateTime created;

  /// The date and time when the program stage was last updated.
  DateTime lastUpdated;

  /// The unique UID of the program stage.
  @override
  @Unique()
  String uid;

  /// The name of the program stage.
  String name;

  /// A description of the program stage.
  String? description;

  /// The sort order for the program stage.
  int? sortOrder;

  /// The validation strategy for the program stage.
  String? validationStrategy;

  /// The feature type for the program stage.
  String? featureType;

  /// The report date to use for the program stage.
  String? reportDateToUse;

  /// The program to which this stage belongs.
  final program = ToOne<D2Program>();

  /// The data elements associated with this program stage.
  @Backlink("programStage")
  final programStageDataElements = ToMany<D2ProgramStageDataElement>();

  /// The sections associated with this program stage.
  @Backlink("programStage")
  final programStageSections = ToMany<D2ProgramStageSection>();

  /// The events associated with this program stage.
  @Backlink()
  final events = ToMany<D2Event>();

  /// Constructs a [D2ProgramStage] instance with the given parameters.
  ///
  /// - [created] The date and time when the program stage was created.
  /// - [displayName] The display name for the program stage.
  /// - [id] The unique identifier for the program stage.
  /// - [lastUpdated] The date and time when the program stage was last updated.
  /// - [uid] The unique UID for the program stage.
  /// - [name] The name of the program stage.
  /// - [sortOrder] The sort order for the program stage.
  /// - [validationStrategy] The validation strategy for the program stage.
  /// - [reportDateToUse] The report date to use for the program stage.
  /// - [featureType] The feature type for the program stage.
  /// - [description] A description of the program stage.
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
  );

  /// Constructs a [D2ProgramStage] instance from a JSON map [json].
  ///
  /// - [db] The [D2ObjectBox] instance used for repository operations.
  /// - [json] The JSON map containing the program stage data.
  D2ProgramStage.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"]),
        uid = json["id"],
        name = json["name"],
        displayName = json["displayName"],
        sortOrder = json["sortOrder"],
        validationStrategy = json["validationStrategy"],
        reportDateToUse = json["reportDateToUse"],
        featureType = json["featureType"],
        description = json["description"] {
    id = D2ProgramStageRepository(db).getIdByUid(json["id"]) ?? 0;
    program.target =
        D2ProgramRepository(db).getByUid(json["program"]?["id"] ?? "");
  }

  /// The display name for the program stage.
  @override
  String? displayName;
}
