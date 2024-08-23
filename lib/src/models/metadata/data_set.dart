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
class D2DataSet extends D2MetaResource {
  @override
  int id = 0;
  DateTime created;

  DateTime lastUpdated;

  @Unique()
  @override
  String uid;

  String name;
  String shortName;
  String? code;
  String periodType;
  int expiryDays;
  int openFuturePeriods;
  int timelyDays;
  int openPeriodsAfterCoEndDate;

  final categoryCombo = ToOne<D2CategoryCombo>();

  @Backlink("dataSet")
  final dataSetElements = ToMany<D2DataSetElement>();
  final legendSets = ToMany<D2LegendSet>();

  final organisationUnits = ToMany<D2OrgUnit>();

  @Backlink("dataSet")
  final compulsoryDataElementOperands =
      ToMany<D2CompulsoryDataElementOperand>();

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

  D2DataSet.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json['created'] ?? json['createdAt']),
        lastUpdated = DateTime.parse(json['lastUpdated'] ?? json['updatedAt']),
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
            (Map json) => D2OrgUnitRepository(db).getByUid(json['id']))
        .toList()
        .cast<D2OrgUnit?>();
    organisationUnits.addAll(orgUnits
        .where((element) => element != null)
        .toList()
        .cast<D2OrgUnit>());
  }
}
