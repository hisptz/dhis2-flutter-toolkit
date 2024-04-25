import '../../../objectbox.g.dart';
import '../../models/metadata/data_set.dart';
import './base.dart';
import 'download_mixins/base_meta_download_mixin.dart';
import 'download_mixins/data_set_download_mixin.dart';

class D2DataSetRepository extends BaseMetaRepository<D2DataSet>
    with
        BaseMetaDownloadServiceMixin<D2DataSet>,
        D2DataSetDownloadServiceMixin {
  D2DataSetRepository(super.db);

  @override
  D2DataSet? getByUid(String uid) {
    Query<D2DataSet> query = box.query(D2DataSet_.uid.equals(uid)).build();
    return query.findFirst();
  }

  @override
  D2DataSet mapper(Map<String, dynamic> json) {
    return D2DataSet.fromMap(db, json);
  }
}
