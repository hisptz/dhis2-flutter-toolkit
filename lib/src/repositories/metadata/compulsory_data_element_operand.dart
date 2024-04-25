import 'package:dhis2_flutter_toolkit/objectbox.g.dart';
import 'package:dhis2_flutter_toolkit/src/models/metadata/compulsory_data_element_operand.dart';

import 'base.dart';

class D2CompulsoryDataElementOperandRepository
    extends BaseMetaRepository<D2CompulsoryDataElementOperand> {
  D2CompulsoryDataElementOperandRepository(super.db);

  @override
  D2CompulsoryDataElementOperand? getByUid(String uid) {
    Query<D2CompulsoryDataElementOperand> query =
        box.query(D2CompulsoryDataElementOperand_.uid.equals(uid)).build();
    return query.findFirst();
  }

  @override
  D2CompulsoryDataElementOperand mapper(Map<String, dynamic> json) {
    return D2CompulsoryDataElementOperand.fromMap(db, json);
  }
}
