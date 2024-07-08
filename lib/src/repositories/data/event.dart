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

/// This class handles repository functions for managing [D2Event] entities.
class D2EventRepository extends D2BaseTrackerDataRepository<D2Event>
    with
        BaseTrackerDataDownloadServiceMixin<D2Event>,
        D2EventDataDownloadServiceMixin,
        D2BaseTrackerDataQueryMixin<D2Event>,
        BaseTrackerDataUploadServiceMixin<D2Event> {
  D2EventRepository(super.db, {super.program});

  /// Stream controller for managing synchronization status updates.
  StreamController<D2SyncStatus> controller = StreamController<D2SyncStatus>();

  /// Retrieves a [D2Event] entity by its unique identifier [uid].
  /// Returns the [D2Event] entity if found, otherwise returns null.
  @override
  D2Event? getByUid(String uid) {
    Query<D2Event> query = box.query(D2Event_.uid.equals(uid)).build();
    return query.findFirst();
  }

  /// Retrieves all [D2Event] entities stored in the database.
  /// Returns a list of [D2Event] entities.
  List<D2Event>? getAll() {
    Query query = box.query().build();
    return query.find() as List<D2Event>;
  }

  /// Maps a JSON object to a [D2Event] entity.
  /// Returns the mapped [D2Event] entity.
  @override
  D2Event mapper(Map<String, dynamic> json) {
    return D2Event.fromMap(db, json);
  }

  /// Filters events by a tracked entity identifier [id].
  /// Returns this [D2EventRepository] instance for chaining.
  D2EventRepository byTrackedEntity(int id) {
    queryConditions = D2Event_.trackedEntity.equals(id);
    return this;
  }

  /// Filters events by an enrollment identifier [id].
  /// Returns this [D2EventRepository] instance for chaining.
  D2EventRepository byEnrollment(int id) {
    queryConditions = D2Event_.enrollment.equals(id);
    return this;
  }

  /// Key used for identifying data when uploading events.
  @override
  String uploadDataKey = "events";

  /// Retrieves a query for unsynchronized [D2Event] entities.
  /// Returns the query for unsynchronized events.
  @override
  Query<D2Event> getUnSyncedQuery() {
    return box.query(D2Event_.synced.equals(false)).build();
  }

  /// Sets the program filter for querying events.
  /// Returns this [D2BaseTrackerDataRepository] instance for chaining.
  @override
  D2BaseTrackerDataRepository<D2Event> setProgram(D2Program program) {
    this.program = program;
    updateQueryCondition(D2Event_.program.equals(program.id));
    return this;
  }

  /// Adds the current program filter to the query conditions.
  @override
  void addProgramToQuery() {
    if (program != null) {}
  }

  /// Retrieves a query for deleted [D2Event] entities.
  /// Returns the query for deleted events.
  @override
  Query<D2Event> getDeletedQuery() {
    return box.query(D2Event_.deleted.equals(true)).build();
  }
}
