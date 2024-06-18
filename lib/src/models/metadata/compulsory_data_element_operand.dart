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

/// This is class represents a compulsory data element operand in DHIS2.

class D2CompulsoryDataElementOperand implements D2MetaResource {
  @override
  int id = 0;

  /// The timestamp when this object was created.
  DateTime created;

  /// The timestamp when this object was last updated.
  DateTime lastUpdated;

  @override
  String uid;

  /// The associated data element.
  final dataElement = ToOne<D2DataElement>();

  /// The associated data set.
  final dataSet = ToOne<D2DataSet>();

  /// The associated category option combo.
  final categoryOptionCombo = ToOne<D2CategoryOptionCombo>();

  /// Creates a [D2CompulsoryDataElementOperand] instance.
  ///
  /// - [id]: The ID of the operand.
  /// - [created]: The timestamp when the operand was created.
  /// - [lastUpdated]: The timestamp when the operand was last updated.
  /// - [uid]: The UID of the operand.
  D2CompulsoryDataElementOperand(
      this.id, this.created, this.lastUpdated, this.uid);

  /// Creates a [D2CompulsoryDataElementOperand] instance from a JSON map.
  ///
  /// - [db]: The ObjectBox database instance.
  /// - [json]: The JSON map representing the operand.
  D2CompulsoryDataElementOperand.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json['created']),
        lastUpdated = DateTime.parse(json['lastUpdated']),
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
