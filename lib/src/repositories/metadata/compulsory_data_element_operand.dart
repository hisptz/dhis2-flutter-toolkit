import 'package:dhis2_flutter_toolkit/objectbox.g.dart';
import 'package:dhis2_flutter_toolkit/src/models/metadata/compulsory_data_element_operand.dart';

import 'base.dart';

/// This is a repository class for managing compulsory data element operands in DHIS2.
class D2CompulsoryDataElementOperandRepository
    extends BaseMetaRepository<D2CompulsoryDataElementOperand> {
  /// Creates a new instance of [D2CompulsoryDataElementOperandRepository].
  ///
  /// - [db]: The ObjectBox database instance.
  D2CompulsoryDataElementOperandRepository(super.db);

  /// Retrieves a compulsory data element operand by its [uid].
  ///
  /// Returns a [D2CompulsoryDataElementOperand] instance if found, otherwise returns `null`.
  ///
  /// - [uid]: The UID of the compulsory data element operand to retrieve.
  @override
  D2CompulsoryDataElementOperand? getByUid(String uid) {
    Query<D2CompulsoryDataElementOperand> query =
        box.query(D2CompulsoryDataElementOperand_.uid.equals(uid)).build();
    return query.findFirst();
  }

  /// Maps a JSON representation to a [D2CompulsoryDataElementOperand] instance.
  ///
  /// - [json]: The JSON map representing the compulsory data element operand.
  ///
  /// Returns a [D2CompulsoryDataElementOperand] instance.
  @override
  D2CompulsoryDataElementOperand mapper(Map<String, dynamic> json) {
    return D2CompulsoryDataElementOperand.fromMap(db, json);
  }
}
