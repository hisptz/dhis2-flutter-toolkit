import 'package:dhis2_flutter_toolkit/src/models/metadata/program.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/data/query_mixin/base_tracker_query_mixin.dart';

import '../../../objectbox.g.dart';
import '../../models/data/enrollment.dart';
import 'base_tracker.dart';
import 'download_mixin/base_tracker_data_download_service_mixin.dart';
import 'download_mixin/enrollment_data_download_service_mixin.dart';
import 'upload_mixin/base_tracker_data_upload_service_mixin.dart';

class D2EnrollmentRepository extends D2BaseTrackerDataRepository<D2Enrollment>
    with
        BaseTrackerDataDownloadServiceMixin<D2Enrollment>,
        D2EnrollmentDownloadServiceMixin,
        D2BaseTrackerDataQueryMixin<D2Enrollment>,
        BaseTrackerDataUploadServiceMixin<D2Enrollment> {
  D2EnrollmentRepository(super.db, {super.program});

  @override
  D2Enrollment? getByUid(String uid) {
    Query<D2Enrollment> query =
        box.query(D2Enrollment_.uid.equals(uid)).build();
    return query.findFirst();
  }

  List<D2Enrollment>? getAll() {
    Query query = box.query().build();
    return query.find() as List<D2Enrollment>;
  }

  @override
  D2Enrollment mapper(Map<String, dynamic> json) {
    return D2Enrollment.fromMap(db, json);
  }

  D2EnrollmentRepository byTrackedEntity(int id) {
    queryConditions = D2Enrollment_.trackedEntity.equals(id);
    return this;
  }

  @override
  String uploadDataKey = "enrollments";

  @override
  Query<D2Enrollment> getUnSyncedQuery() {
    return box.query(D2Enrollment_.synced.equals(false)).build();
  }

  @override
  D2BaseTrackerDataRepository<D2Enrollment> setProgram(D2Program program) {
    this.program = program;
    return this;
  }

  @override
  void addProgramToQuery() {
    if (program != null) {
      updateQueryCondition(D2Enrollment_.program.equals(program!.id));
    }
  }
}
