import '../../../objectbox.g.dart';
import '../../models/metadata/data_set_element.dart';
import 'base.dart';

class D2DataSetElementRepository extends BaseMetaRepository<D2DataSetElement> {
  D2DataSetElementRepository(super.db);

  @override
  D2DataSetElement? getByUid(String uid) {
    Query<D2DataSetElement> query =
        box.query(D2DataSetElement_.uid.equals(uid)).build();
    return query.findFirst();
  }

  @override
  D2DataSetElement mapper(Map<String, dynamic> json) {
    return D2DataSetElement.fromMap(db, json);
  }
}
