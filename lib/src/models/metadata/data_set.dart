import 'package:dhis2_flutter_toolkit/src/models/metadata/compulsory_data_element_operand.dart';
import 'package:objectbox/objectbox.dart';
import '../../../objectbox.dart';
import '../../repositories/metadata/entry.dart';
import './base.dart';
import 'category_combo.dart';
import 'data_set_element.dart';
import 'legend_set.dart';
import 'org_unit.dart';

@Entity()

/// This class represents a data set in the DHIS2 system.
class D2DataSet extends D2MetaResource {
  /// The unique identifier for the data set.
  @override
  int id = 0;

  /// The date and time when the data set was created.
  DateTime created;

  /// The date and time when the data set was last updated.
  DateTime lastUpdated;

  /// The unique identifier (UID) for the data set.
  @Unique()
  @override
  String uid;

  /// The name of the data set.
  String name;

  /// A short name for the data set.
  String shortName;

  /// An optional code associated with the data set.
  String? code;

  /// The period type for the data set (e.g., daily, weekly, monthly).
  String periodType;

  /// The number of days after which the data set expires.
  int expiryDays;

  /// The number of future periods that are open for data entry.
  int openFuturePeriods;

  /// The number of days within which data entry is considered timely.
  int timelyDays;

  /// The number of periods open after the completion of the end date.
  int openPeriodsAfterCoEndDate;

  /// The category combination associated with the data set.
  final categoryCombo = ToOne<D2CategoryCombo>();

  /// The data set elements associated with the data set.
  @Backlink("dataSet")
  final dataSetElements = ToMany<D2DataSetElement>();

  /// The legend sets associated with the data set.
  final legendSets = ToMany<D2LegendSet>();

  /// The organisation units associated with the data set.
  final organisationUnits = ToMany<D2OrgUnit>();

  /// The compulsory data element operands associated with the data set.
  @Backlink("dataSet")
  final compulsoryDataElementOperands =
      ToMany<D2CompulsoryDataElementOperand>();

  /// Creates a new instance of [D2DataSet].
  ///
  /// The constructor initializes all required properties.
  ///
  /// - [id] The unique identifier for the data set.
  /// - [shortName] The short name for the data set.
  /// - [lastUpdated] The date and time when the data set was last updated.
  /// - [name] The name of the data set.
  /// - [code] An optional code associated with the data set.
  /// - [created] The date and time when the data set was created.
  /// - [periodType] The period type for the data set.
  /// - [expiryDays] The number of days after which the data set expires.
  /// - [timelyDays] The number of days within which data entry is considered timely.
  /// - [uid] The unique identifier (UID) for the data set.
  /// - [openFuturePeriods] The number of future periods that are open for data entry.
  /// - [openPeriodsAfterCoEndDate] The number of periods open after the completion of the end date.

  D2DataSet(
    this.id,
    this.shortName,
    this.lastUpdated,
    this.name,
    this.code,
    this.created,
    this.periodType,
    this.expiryDays,
    this.timelyDays,
    this.uid,
    this.openFuturePeriods,
    this.openPeriodsAfterCoEndDate,
  );

  /// Creates a new instance of [D2DataSet] from a map.
  ///
  /// - [db] The database reference for fetching related entities.
  /// - [json] The JSON map containing the data set information.
  D2DataSet.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json['created']),
        lastUpdated = DateTime.parse(json['lastUpdated']),
        uid = json['id'],
        name = json['name'],
        code = json['code'],
        periodType = json['periodType'],
        expiryDays = json['expiryDays'],
        timelyDays = json['timelyDays'],
        openFuturePeriods = json['openFuturePeriods'],
        openPeriodsAfterCoEndDate = json['openPeriodsAfterCoEndDate'],
        shortName = json['shortName'] {
    id = D2DataSetRepository(db).getIdByUid(json["id"]) ?? 0;

    categoryCombo.target = D2CategoryComboRepository(db)
        .getByUid(json['categoryCombo']?['id'] ?? '');

    List<D2DataSetElement> elements = json['dataSetElements']
        .cast<Map>()
        .map<D2DataSetElement>((Map json) => D2DataSetElement.fromMap(db, json))
        .toList();
    dataSetElements.addAll(elements);

    List<D2CompulsoryDataElementOperand> compulsoryElements =
        json['compulsoryDataElementOperands']
            .cast<Map>()
            ?.map<D2CompulsoryDataElementOperand>((Map element) =>
                D2CompulsoryDataElementOperand.fromMap(db, element))
            .toList()
            .cast<D2CompulsoryDataElementOperand>();
    compulsoryDataElementOperands.addAll(compulsoryElements);

    List<D2OrgUnit?> orgUnits = json['organisationUnits']
        .cast<Map>()
        .map<D2OrgUnit?>(
            (Map json) => D2OrgUnitRepository(db).getByUid(json['id'])!)
        .toList()
        .cast<D2OrgUnit?>();
    organisationUnits.addAll(orgUnits
        .where((element) => element != null)
        .toList()
        .cast<D2OrgUnit>());
  }
}
