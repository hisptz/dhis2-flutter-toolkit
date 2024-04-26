import 'dart:async';

import 'package:dhis2_flutter_toolkit/src/models/metadata/program.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/data/query_mixin/base_tracker_query_mixin.dart';

import '../../../objectbox.g.dart';
import '../../models/data/event.dart';
import '../../utils/sync_status.dart';
import 'base_tracker.dart';
import 'download_mixin/base_tracker_data_download_service_mixin.dart';
import 'download_mixin/event_data_download_service_mixin.dart';
import 'upload_mixin/base_tracker_data_upload_service_mixin.dart';

class D2EventRepository extends D2BaseTrackerDataRepository<D2Event>
    with
        BaseTrackerDataDownloadServiceMixin<D2Event>,
        D2EventDataDownloadServiceMixin,
        D2BaseTrackerDataQueryMixin<D2Event>,
        BaseTrackerDataUploadServiceMixin<D2Event> {
  D2EventRepository(super.db, {super.program});

  StreamController<D2SyncStatus> controller = StreamController<D2SyncStatus>();

  @override
  D2Event? getByUid(String uid) {
    Query<D2Event> query = box.query(D2Event_.uid.equals(uid)).build();
    return query.findFirst();
  }

  List<D2Event>? getAll() {
    Query query = box.query().build();
    return query.find() as List<D2Event>;
  }

  @override
  D2Event mapper(Map<String, dynamic> json) {
    return D2Event.fromMap(db, json);
  }

  D2EventRepository byTrackedEntity(int id) {
    queryConditions = D2Event_.trackedEntity.equals(id);
    return this;
  }

  D2EventRepository byEnrollment(int id) {
    queryConditions = D2Event_.enrollment.equals(id);
    return this;
  }

  @override
  String uploadDataKey = "events";

  @override
  Query<D2Event> getUnSyncedQuery() {
    return box.query(D2Event_.synced.equals(false)).build();
  }

  @override
  D2BaseTrackerDataRepository<D2Event> setProgram(D2Program program) {
    this.program = program;
    updateQueryCondition(D2Event_.program.equals(program.id));
    return this;
  }

  @override
  void addProgramToQuery() {
    if (program != null) {}
  }
}
