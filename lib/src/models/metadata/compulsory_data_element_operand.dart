import 'package:dhis2_flutter_toolkit/src/repositories/metadata/category_option_combo.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/metadata/compulsory_data_element_operand.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/metadata/data_set.dart';
import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import '../../repositories/metadata/data_element.dart';
import 'base.dart';
import 'category_option_combo.dart';
import 'data_element.dart';
import 'data_set.dart';

@Entity()
class D2CompulsoryDataElementOperand implements D2MetaResource {
  @override
  int id = 0;

  DateTime created;
  DateTime lastUpdated;

  @Unique()
  @override
  String uid;

  String name;
  String shortName;
  String displayName;

  final dataElement = ToOne<D2DataElement>();
  final dataSet = ToOne<D2DataSet>();
  final categoryOptionCombo = ToOne<D2CategoryOptionCombo>();

  D2CompulsoryDataElementOperand(this.id, this.created, this.lastUpdated,
      this.uid, this.name, this.shortName, this.displayName);

  D2CompulsoryDataElementOperand.fromMap(D2ObjectBox db,
      {D2DataSet? dataSet, required Map json})
      : created = DateTime.parse(json['created']),
        lastUpdated = DateTime.parse(json['lastUpdated']),
        uid = json['id'],
        name = json['name'],
        displayName = json['displayName'],
        shortName = json['shortName'] {
    id = D2CompulsoryDataElementOperandRepository(db).getIdByUid(uid) ?? 0;
    this.dataSet.target =
        dataSet ?? D2DataSetRepository(db).getByUid(json['dataSet']['id']);
    dataElement.target =
        D2DataElementRepository(db).getByUid(json['dataElement']['id']);
    categoryOptionCombo.target = D2CategoryOptionComboRepository(db)
        .getByUid(json['categoryOptionCombo']['id']);
  }
}
