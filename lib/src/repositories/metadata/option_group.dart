import '../../../objectbox.g.dart';
import '../../models/metadata/option_group.dart';
import 'base.dart';

class D2OptionGroupRepository extends BaseMetaRepository<D2OptionGroup> {
  D2OptionGroupRepository(super.db);

  @override
  D2OptionGroup? getByUid(String uid) {
    Query<D2OptionGroup> query =
        box.query(D2OptionGroup_.uid.equals(uid)).build();
    return query.findFirst();
  }

  @override
  D2OptionGroup mapper(Map<String, dynamic> json) {
    return D2OptionGroup.fromMap(db, json);
  }
}
