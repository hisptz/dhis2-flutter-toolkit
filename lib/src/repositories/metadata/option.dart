import '../../../objectbox.g.dart';

import '../../models/metadata/option.dart';
import 'base.dart';

class D2OptionRepository extends BaseMetaRepository<D2Option> {
  D2OptionRepository(super.db);

  @override
  D2Option? getByUid(String uid) {
    Query<D2Option> query = box.query(D2Option_.uid.equals(uid)).build();
    return query.findFirst();
  }

  @override
  D2Option mapper(Map<String, dynamic> json) {
    return D2Option.fromMap(db, json);
  }
}
