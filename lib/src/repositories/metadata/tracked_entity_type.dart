
import '../../../objectbox.g.dart';

import '../../models/metadata/tracked_entity_type.dart';
import 'base.dart';
import 'download_mixins/base_meta_download_mixin.dart';
import 'download_mixins/tracked_entity_type_download_mixin.dart';
class D2TrackedEntityTypeRepository
    extends BaseMetaRepository<D2TrackedEntityType>
    with
        BaseMetaDownloadServiceMixin<D2TrackedEntityType>,
        D2TrackedEntityTypeDownloadServiceMixin {
  D2TrackedEntityTypeRepository(super.db);

  @override
  D2TrackedEntityType? getByUid(String uid) {
    Query<D2TrackedEntityType> query =
        box.query(D2TrackedEntityType_.uid.equals(uid)).build();
    return query.findFirst();
  }

  @override
  D2TrackedEntityType mapper(Map<String, dynamic> json) {
    return D2TrackedEntityType.fromMap(db, json);
  }
}
