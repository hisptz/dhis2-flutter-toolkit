import 'package:dhis2_flutter_toolkit/src/repositories/metadata/download_mixins/base_single_meta_download_mixin.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/metadata/download_mixins/option_set_download_service_mixin.dart';

import '../../../objectbox.g.dart';

import '../../models/metadata/option_set.dart';
import 'base.dart';

class D2OptionSetRepository extends BaseMetaRepository<D2OptionSet>
    with
        BaseSingleMetaDownloadServiceMixin<D2OptionSet>,
        D2OptionSetDownloadServiceMixin {
  D2OptionSetRepository(super.db);

  @override
  D2OptionSet? getByUid(String uid) {
    Query<D2OptionSet> query = box.query(D2OptionSet_.uid.equals(uid)).build();
    return query.findFirst();
  }

  @override
  D2OptionSet mapper(Map<String, dynamic> json) {
    return D2OptionSet.fromMap(db, json);
  }
}
