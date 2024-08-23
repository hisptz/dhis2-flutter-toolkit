import '../../../objectbox.g.dart';
import '../../models/metadata/data_element.dart';
import 'base.dart';

class D2DataElementRepository extends BaseMetaRepository<D2DataElement> {
  D2DataElementRepository(super.db);

  @override
  D2DataElement? getByUid(String uid) {
    Query<D2DataElement> query =
        box.query(D2DataElement_.uid.equals(uid)).build();
    return query.findFirst();
  }

  @override
  D2DataElement mapper(Map<String, dynamic> json) {
    return D2DataElement.fromMap(db, json);
  }
}
