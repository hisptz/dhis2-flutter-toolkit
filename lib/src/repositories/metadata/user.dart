import 'base.dart';
import '../../models/metadata/user.dart';
import 'download_mixins/base_single_meta_download_mixin.dart';
import 'download_mixins/user_download_mixin.dart';

import '../../../objectbox.g.dart';


class D2UserRepository extends BaseMetaRepository<D2User>
    with
        BaseSingleMetaDownloadServiceMixin<D2User>,
        D2UserDownloadServiceMixin {
  D2UserRepository(super.db);

  @override
  int? getIdByUid(String uid) {
    return getByUid(uid)?.id;
  }

  D2User? get() {
    Query query = box.query().build();
    return query.findFirst();
  }

  @override
  D2User? getByUid(String uid) {
    Query<D2User> query = box.query(D2User_.uid.equals(uid)).build();
    return query.findFirst();
  }

  @override
  D2User mapper(Map<String, dynamic> json) {
    return D2User.fromMap(db, json);
  }
}
