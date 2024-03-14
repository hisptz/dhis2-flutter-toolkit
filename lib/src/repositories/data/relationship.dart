import 'dart:async';

import 'package:dhis2_flutter_toolkit/src/models/metadata/program.dart';

import '../../../objectbox.g.dart';
import '../../models/data/relationship.dart';
import '../../utils/sync_status.dart';
import 'base.dart';
import 'upload_mixin/base_tracker_data_upload_service_mixin.dart';

class D2RelationshipRepository extends BaseDataRepository<D2Relationship>
    with BaseTrackerDataUploadServiceMixin<D2Relationship> {
  D2RelationshipRepository(super.db, {super.program});

  StreamController<D2SyncStatus> controller = StreamController<D2SyncStatus>();

  @override
  D2Relationship? getByUid(String uid) {
    Query<D2Relationship> query =
        box.query(D2Relationship_.uid.equals(uid)).build();
    return query.findFirst();
  }

  @override
  D2Relationship mapper(Map<String, dynamic> json) {
    return D2Relationship.fromMap(db, json);
  }

  @override
  String label = "Enrollments";

  @override
  String uploadDataKey = "enrollments";

  @override
  setUnSyncedQuery() {
    if (queryConditions != null) {
      queryConditions!.and(D2Relationship_.synced.equals(true));
    } else {
      queryConditions = D2Relationship_.synced.equals(true);
    }
  }

  @override
  BaseDataRepository<D2Relationship> setProgram(D2Program program) {
    this.program;
    return this;
  }
}