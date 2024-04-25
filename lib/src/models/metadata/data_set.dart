import 'package:dhis2_flutter_toolkit/src/models/metadata/compulsory_data_element_operand.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/metadata/data_set.dart';
import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import './base.dart';
import 'category_combo.dart';
import 'data_set_element.dart';
import 'legend_set.dart';

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
  final dataSetElements = ToMany<D2DataSetElement>();
  final legendSets = ToMany<D2LegendSet>();

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

    List<D2DataSetElement> elements = json['dataSetElements']
        .map<D2DataSetElement>(
            (Map json) => D2DataSetElement.fromMap(db, json));
    dataSetElements.addAll(elements);
    List<D2CompulsoryDataElementOperand> compulsoryElements =
        json['compulsoryDataElementOperands']
            ?.map<D2CompulsoryDataElementOperand>((Map element) =>
                D2CompulsoryDataElementOperand.fromMap(db,
                    json: json, dataSet: this));

    compulsoryDataElementOperands.addAll(compulsoryElements);
  }
}
