import 'package:dhis2_flutter_toolkit/src/repositories/metadata/download_mixins/base_single_meta_download_mixin.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/metadata/download_mixins/option_download_mixin.dart';

import '../../../objectbox.g.dart';

import '../../models/metadata/option.dart';
import 'base.dart';

class D2OptionRepository extends BaseMetaRepository<D2Option>
    with
        BaseSingleMetaDownloadServiceMixin<D2Option>,
        D2OptionDownloadServiceMixin {
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
