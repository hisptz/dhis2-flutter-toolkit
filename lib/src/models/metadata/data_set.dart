import 'package:dhis2_flutter_toolkit/src/repositories/metadata/data_set.dart';
import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import './base.dart';
import 'category_combo.dart';
import 'data_element.dart';
import 'legend_set.dart';

@Entity()
class D2DataSet extends D2MetaResource {
  @override
  int id = 0;
  @override
  DateTime created;

  @override
  DateTime lastUpdated;

  @override
  String uid;

  String name;
  String shortName;
  String code;
  String periodType;
  int expiryDays;
  int openFuturePeriods;
  int timelyDays;
  int openPeriodsAfterCoEndDate;

  final categoryCombo = ToOne<D2CategoryCombo>();
  final dataSetElements = ToMany<D2DataElement>();
  final legendSets = ToMany<D2LegendSet>();

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
  }
}
