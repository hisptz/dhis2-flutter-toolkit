import 'dart:async';

import 'package:dhis2_flutter_toolkit/src/models/metadata/program.dart';

import '../../../objectbox.g.dart';
import '../../models/data/tracked_entity.dart';
import '../../utils/sync_status.dart';
import 'base.dart';
import 'download_mixin/base_tracker_data_download_service_mixin.dart';
import 'download_mixin/tracked_entity_data_download_service_mixin.dart';
import 'upload_mixin/base_tracker_data_upload_service_mixin.dart';

class D2TrackedEntityRepository extends BaseDataRepository<D2TrackedEntity>
    with
        BaseTrackerDataDownloadServiceMixin<D2TrackedEntity>,
        TrackedEntityDataDownloadServiceMixin,
        BaseTrackerDataUploadServiceMixin<D2TrackedEntity> {
  D2TrackedEntityRepository(super.db, {super.program});

  StreamController<D2SyncStatus> controller = StreamController<D2SyncStatus>();

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

  @override
  String uploadDataKey = "trackedEntities";

  @override
  setUnSyncedQuery() {
    updateQueryCondition(D2TrackedEntity_.synced.equals(true));
  }

  @override
  BaseDataRepository<D2TrackedEntity> setProgram(D2Program program) {
    this.program = program;
    return this;
  }
}
