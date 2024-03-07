import '../../models/metadata/system_info.dart';
import 'base.dart';
import 'download_mixins/base_single_meta_download_mixin.dart';
import 'download_mixins/system_info_download_mixin.dart';
import '../../../objectbox.g.dart';


class D2SystemInfoRepository extends BaseMetaRepository<D2SystemInfo>
    with
        BaseSingleMetaDownloadServiceMixin<D2SystemInfo>,
        D2SystemInfoDownloadServiceMixin {
  D2SystemInfoRepository(super.db);

  @override
  int? getIdByUid(String uid) {
    return getByUid(uid)?.id;
  }

  D2SystemInfo? get() {
    Query<D2SystemInfo> query = box.query().build();
    return query.findFirst();
  }

  @override
  D2SystemInfo? getByUid(String uid) {
    Query<D2SystemInfo> query =
        box.query(D2SystemInfo_.systemId.equals(uid)).build();
    return query.findFirst();
  }

  @override
  D2SystemInfo mapper(Map<String, dynamic> json) {
    return D2SystemInfo.fromMap(db, json);
  }
}
