import '../../../objectbox.g.dart';
import '../../models/metadata/category.dart';
import './base.dart';

class D2CategoryOptionRepository extends BaseMetaRepository<D2Category> {
  D2CategoryOptionRepository(super.db);

  @override
  D2Category? getByUid(String uid) {
    Query<D2Category> query = box.query(D2Category_.uid.equals(uid)).build();
    return query.findFirst();
  }

  @override
  D2Category mapper(Map<String, dynamic> json) {
    return D2Category.fromMap(db, json);
  }
}
