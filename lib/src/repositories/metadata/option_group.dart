import 'package:dhis2_flutter_toolkit/src/repositories/metadata/download_mixins/base_single_meta_download_mixin.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/metadata/download_mixins/option_group_download_mixin.dart';

import '../../../objectbox.g.dart';
import '../../models/metadata/option_group.dart';
import 'base.dart';

class D2OptionGroupRepository extends BaseMetaRepository<D2OptionGroup>
    with
        BaseSingleMetaDownloadServiceMixin<D2OptionGroup>,
        D2OptionGroupDownloadServiceMixin {
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
