import '../../../objectbox.g.dart';
import '../../models/metadata/category_option_combo.dart';
import './base.dart';

class D2CategoryOptionComboRepository
    extends BaseMetaRepository<D2CategoryOptionCombo> {
  D2CategoryOptionComboRepository(super.db);

  @override
  D2CategoryOptionCombo? getByUid(String uid) {
    Query<D2CategoryOptionCombo> query =
        box.query(D2CategoryOptionCombo_.uid.equals(uid)).build();
    return query.findFirst();
  }

  @override
  D2CategoryOptionCombo mapper(Map<String, dynamic> json) {
    return D2CategoryOptionCombo.fromMap(db, json);
  }
}
