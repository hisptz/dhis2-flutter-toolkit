import 'package:dhis2_flutter_toolkit/src/repositories/data/query_mixin/base_tracker_query_mixin.dart';

import '../../../objectbox.g.dart';
import '../../models/data/entry.dart';
import '../../models/metadata/entry.dart';
import 'base_tracker.dart';
import 'upload_mixin/base_tracker_data_upload_service_mixin.dart';

class D2RelationshipRepository
    extends D2BaseTrackerDataRepository<D2Relationship>
    with
        D2BaseTrackerDataQueryMixin<D2Relationship>,
        BaseTrackerDataUploadServiceMixin<D2Relationship> {
  D2RelationshipRepository(super.db, {super.program});

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
  String label = "Relationships";

  @override
  String uploadDataKey = "relationships";

  @override
  Query<D2Relationship> getUnSyncedQuery() {
    return box.query(D2Relationship_.synced.equals(false)).build();
  }

  @override
  D2BaseTrackerDataRepository<D2Relationship> setProgram(D2Program program) {
    this.program = program;
    return this;
  }

  @override
  void addProgramToQuery() {
    // TODO: implement addProgramToQuery
  }

  D2Relationship? getByConstraints(
      {required D2DataResource from,
      required D2DataResource to,
      required D2RelationshipType type}) {
    Condition<D2Relationship> condition =
        D2Relationship_.relationshipType.equals(type.id);
    if (from is D2TrackedEntity) {
      condition.and(D2Relationship_.fromTrackedEntity.equals(from.id));
    }
    if (from is D2Enrollment) {
      condition.and(D2Relationship_.fromEnrollment.equals(from.id));
    }
    if (from is D2Event) {
      condition.and(D2Relationship_.fromEvent.equals(from.id));
    }

    if (to is D2TrackedEntity) {
      condition.and(D2Relationship_.toTrackedEntity.equals(to.id));
    }

    if (to is D2Enrollment) {
      condition.and(D2Relationship_.toEnrollment.equals(to.id));
    }

    if (to is D2Event) {
      condition.and(D2Relationship_.toEvent.equals(to.id));
    }
    return box.query(condition).build().findFirst();
  }

  @override
  Query<D2Relationship> getDeletedQuery() {
    return box.query(D2Relationship_.deleted.equals(true)).build();
  }
}
