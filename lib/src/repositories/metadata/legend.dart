
import '../../../objectbox.g.dart';

import '../../models/metadata/legend.dart';
import 'base.dart';

class D2LegendRepository extends BaseMetaRepository<D2Legend> {
  D2LegendRepository(super.db);

  @override
  D2Legend? getByUid(String uid) {
    Query<D2Legend> query = box.query(D2Legend_.uid.equals(uid)).build();
    return query.findFirst();
  }

  @override
  D2Legend mapper(Map<String, dynamic> json) {
    return D2Legend.fromMap(db, json);
  }
}
