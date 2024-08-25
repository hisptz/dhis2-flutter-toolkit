import '../../../objectbox.g.dart';
import '../../models/metadata/option_group_set.dart';
import 'base.dart';

class D2OptionGroupSetRepository extends BaseMetaRepository<D2OptionGroupSet> {
  D2OptionGroupSetRepository(super.db);

  @override
  D2OptionGroupSet? getByUid(String uid) {
    Query<D2OptionGroupSet> query =
        box.query(D2OptionGroupSet_.uid.equals(uid)).build();
    return query.findFirst();
  }

  @override
  D2OptionGroupSet mapper(Map<String, dynamic> json) {
    return D2OptionGroupSet.fromMap(db, json);
  }
}
