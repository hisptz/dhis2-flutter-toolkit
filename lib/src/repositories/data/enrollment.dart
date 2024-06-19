import 'package:dhis2_flutter_toolkit/src/models/metadata/program.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/data/query_mixin/base_tracker_query_mixin.dart';

import '../../../objectbox.g.dart';
import '../../models/data/enrollment.dart';
import 'base_tracker.dart';
import 'download_mixin/base_tracker_data_download_service_mixin.dart';
import 'download_mixin/enrollment_data_download_service_mixin.dart';
import 'upload_mixin/base_tracker_data_upload_service_mixin.dart';

/// This class handles the repository functions for managing [D2Enrollment] data in the DHIS2 system.
class D2EnrollmentRepository extends D2BaseTrackerDataRepository<D2Enrollment>
    with
        BaseTrackerDataDownloadServiceMixin<D2Enrollment>,
        D2EnrollmentDownloadServiceMixin,
        D2BaseTrackerDataQueryMixin<D2Enrollment>,
        BaseTrackerDataUploadServiceMixin<D2Enrollment> {
  /// Constructs a [D2EnrollmentRepository] instance.
  /// Parameters:
  /// - [db]: The ObjectBox database instance.
  /// - [program]: Optional. The DHIS2 program associated with the enrollments.
  D2EnrollmentRepository(super.db, {super.program});

  /// Retrieves a [D2Enrollment] object by its unique identifier [uid].
  /// Returns a [D2Enrollment] object if found, otherwise returns null.
  @override
  D2Enrollment? getByUid(String uid) {
    Query<D2Enrollment> query =
        box.query(D2Enrollment_.uid.equals(uid)).build();
    return query.findFirst();
  }

  /// Retrieves all [D2Enrollment] objects from the database.
  /// Returns a list of [D2Enrollment] objects.
  List<D2Enrollment>? getAll() {
    Query query = box.query().build();
    return query.find() as List<D2Enrollment>;
  }

  /// Maps a JSON object to a [D2Enrollment] object.
  @override
  D2Enrollment mapper(Map<String, dynamic> json) {
    return D2Enrollment.fromMap(db, json);
  }

  /// Filters the query by a specific tracked entity ID.
  /// Returns this repository instance.
  D2EnrollmentRepository byTrackedEntity(int id) {
    queryConditions = D2Enrollment_.trackedEntity.equals(id);
    return this;
  }

  /// Specifies the key for uploading enrollments data.
  @override
  String uploadDataKey = "enrollments";

  /// Retrieves a query for unsynced [D2Enrollment] objects.
  @override
  Query<D2Enrollment> getUnSyncedQuery() {
    return box.query(D2Enrollment_.synced.equals(false)).build();
  }

  /// Sets the DHIS2 program associated with the enrollments.
  /// Returns this repository instance.
  @override
  D2BaseTrackerDataRepository<D2Enrollment> setProgram(D2Program program) {
    this.program = program;
    return this;
  }

  /// Adds the current program to the query condition.
  @override
  void addProgramToQuery() {
    if (program != null) {
      updateQueryCondition(D2Enrollment_.program.equals(program!.id));
    }
  }

  /// Retrieves a query for deleted [D2Enrollment] objects.
  @override
  Query<D2Enrollment> getDeletedQuery() {
    return box.query(D2Enrollment_.deleted.equals(true)).build();
  }
}
