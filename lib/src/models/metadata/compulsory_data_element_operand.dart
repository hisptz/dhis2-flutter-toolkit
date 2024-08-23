import 'package:dhis2_flutter_toolkit/src/repositories/metadata/category_option_combo.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/metadata/compulsory_data_element_operand.dart';
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

  @override
  String uid;

  final dataElement = ToOne<D2DataElement>();
  final dataSet = ToOne<D2DataSet>();
  final categoryOptionCombo = ToOne<D2CategoryOptionCombo>();

  D2CompulsoryDataElementOperand(
      this.id, this.created, this.lastUpdated, this.uid);

  D2CompulsoryDataElementOperand.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json['created'] ?? json['createdAt']),
        lastUpdated = DateTime.parse(json['lastUpdated'] ?? json['updatedAt']),
        uid = json['id'] {
    id = D2CompulsoryDataElementOperandRepository(db).getIdByUid(uid) ?? 0;

    Map? dataElement = json['dataElement'];
    Map? categoryOptionCombo = json['categoryOptionCombo'];

    if (dataElement != null) {
      this.dataElement.target =
          D2DataElementRepository(db).getByUid(dataElement['id']);
    }
    if (categoryOptionCombo != null) {
      this.categoryOptionCombo.target = D2CategoryOptionComboRepository(db)
          .getByUid(categoryOptionCombo['id']);
    }
  }
}
