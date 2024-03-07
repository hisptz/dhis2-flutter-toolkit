import 'dart:async';
import 'package:objectbox/objectbox.dart';

import '../../../objectbox.g.dart';
import '../../models/data/trackedEntity.dart';
import '../../utils/download_status.dart';
import 'base.dart';
import 'download_mixin/base_tracker_data_download_service_mixin.dart';
import 'download_mixin/tracked_entity_data_download_service_mixin.dart';
import 'trackedEntityAttributeValue.dart';
import 'upload_mixin/base_tracker_data_upload_service_mixin.dart';
class D2TrackedEntityRepository extends BaseDataRepository<D2TrackedEntity>
    with
        BaseTrackerDataDownloadServiceMixin<D2TrackedEntity>,
        TrackedEntityDataDownloadServiceMixin,
        BaseTrackerDataUploadServiceMixin<D2TrackedEntity> {
  D2TrackedEntityRepository(super.db);

  StreamController<DownloadStatus> controller =
      StreamController<DownloadStatus>();

  @override
  D2TrackedEntity? getByUid(String uid) {
    Query<D2TrackedEntity> query =
        box.query(D2TrackedEntity_.uid.equals(uid)).build();
    return query.findFirst();
  }

  List<D2TrackedEntity>? getAll() {
    Query query = box.query().build();
    return query.find() as List<D2TrackedEntity>;
  }

  @override
  D2TrackedEntity mapper(Map<String, dynamic> json) {
    return D2TrackedEntity.fromMap(db, json);
  }

  D2TrackedEntityRepository byIdentifiableToken(String keyword) {
    final trackedEntities = box.getAll();

    final matchingEntities = trackedEntities.where((trackedEntity) {
      final attributeEntities = D2TrackedEntityAttributeValueRepository(db)
          .byTrackedEntity(trackedEntity.id)
          .find();

      final nameAttributes = attributeEntities.where((attribute) =>
          (attribute.trackedEntityAttribute.target?.name == "First name") ||
          (attribute.trackedEntityAttribute.target?.name == "Last name"));

      return nameAttributes.any((attribute) =>
          attribute.value.toLowerCase().contains(keyword.toLowerCase()));
    });

    final uidList = matchingEntities.map((entity) => entity.uid).toList();

    queryConditions = D2TrackedEntity_.uid
        .oneOf(uidList.isNotEmpty ? uidList : ["null"], caseSensitive: false);

    return this;
  }

  @override
  String uploadDataKey = "trackedEntities";

  @override
  setUnSyncedQuery() {
    if (queryConditions != null) {
      queryConditions!.and(D2TrackedEntity_.synced.equals(true));
    } else {
      queryConditions = D2TrackedEntity_.synced.equals(true);
    }
  }
}
