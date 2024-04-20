import '../../../objectbox.g.dart';
import '../../models/metadata/category_option.dart';
import './base.dart';

class D2CategoryOptionRepository extends BaseMetaRepository<D2CategoryOption> {
  D2CategoryOptionRepository(super.db);

  @override
  D2CategoryOption? getByUid(String uid) {
    Query<D2CategoryOption> query =
        box.query(D2CategoryOption_.uid.equals(uid)).build();
    return query.findFirst();
  }

  @override
  D2CategoryOption mapper(Map<String, dynamic> json) {
    return D2CategoryOption.fromMap(db, json);
  }
}
