import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/data_element.dart';
import '../../repositories/metadata/program_stage.dart';
import '../../repositories/metadata/program_stage_data_element.dart';
import 'base.dart';
import 'data_element.dart';
import 'program_stage.dart';

@Entity()

/// This is class represents a data element within a program stage.
///
/// This class contains information about a specific data element associated
/// with a program stage, including whether it's compulsory, its sort order,
/// and other related properties.
class D2ProgramStageDataElement extends D2MetaResource {
  /// The date when this data element was created.
  @override
  DateTime created;

  @override
  int id = 0;

  /// The date when this data element was last updated.
  @override
  DateTime lastUpdated;

  /// The UID (unique identifier) of this data element.
  @override
  String uid;

  /// Indicates whether this data element is compulsory.
  bool compulsory;

  /// The sort order of this data element within the program stage.
  int? sortOrder;

  /// Indicates whether future dates are allowed for this data element.
  bool? allowFutureDate;

  /// Indicates whether options should be rendered as radio buttons.
  bool? renderOptionsAsRadio;

  /// The program stage associated with this data element.
  final programStage = ToOne<D2ProgramStage>();

  /// The data element associated with this program stage data element.
  final dataElement = ToOne<D2DataElement>();

  /// Creates a new instance of [D2ProgramStageDataElement].
  ///
  /// - [created] is the date when this data element was created.
  /// - [id] is the unique identifier for this data element.
  /// - [lastUpdated] is the date when this data element was last updated.
  /// - [uid] is the UID (unique identifier) of this data element.
  /// - [compulsory] indicates whether this data element is compulsory.
  /// - [sortOrder] is the sort order of this data element within the program stage.
  /// - [allowFutureDate] indicates whether future dates are allowed for this data element.
  /// - [displayName] is the display name of this data element.
  /// - [renderOptionsAsRadio] indicates whether options should be rendered as radio buttons.

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

  /// Creates a new instance of [D2ProgramStageDataElement] from a map [json].
  ///
  /// - [db] is the database instance.
  /// - [json] is the map containing the data to initialize this instance.
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

  /// The display name of this data element.
  @override
  String? displayName;
}
