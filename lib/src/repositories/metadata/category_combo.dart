import 'package:dhis2_flutter_toolkit/src/models/metadata/category_combo.dart';

import '../../../objectbox.g.dart';
import './base.dart';

class D2CategoryComboRepository extends BaseMetaRepository<D2CategoryCombo> {
  D2CategoryComboRepository(super.db);

  @override
  D2CategoryCombo? getByUid(String uid) {
    Query<D2CategoryCombo> query =
        box.query(D2CategoryCombo_.uid.equals(uid)).build();
    return query.findFirst();
  }

  @override
  D2CategoryCombo mapper(Map<String, dynamic> json) {
    return D2CategoryCombo.fromMap(db, json);
  }
}
