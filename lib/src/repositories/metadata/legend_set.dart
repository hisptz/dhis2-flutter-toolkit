import '../../../objectbox.g.dart';

import '../../models/metadata/legend_set.dart';
import 'base.dart';

class D2LegendSetRepository extends BaseMetaRepository<D2LegendSet> {
  D2LegendSetRepository(super.db);

  @override
  D2LegendSet? getByUid(String uid) {
    Query<D2LegendSet> query = box.query(D2LegendSet_.uid.equals(uid)).build();
    return query.findFirst();
  }

  @override
  D2LegendSet mapper(Map<String, dynamic> json) {
    return D2LegendSet.fromMap(db, json);
  }
}
