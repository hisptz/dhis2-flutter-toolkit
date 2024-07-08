import 'dart:async';

import 'package:dhis2_flutter_toolkit/src/models/metadata/program.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/data/query_mixin/base_tracker_query_mixin.dart';

import '../../../objectbox.g.dart';
import '../../models/data/tracked_entity.dart';
import '../../utils/sync_status.dart';
import 'base_tracker.dart';
import 'download_mixin/base_tracker_data_download_service_mixin.dart';
import 'download_mixin/tracked_entity_data_download_service_mixin.dart';
import 'upload_mixin/base_tracker_data_upload_service_mixin.dart';

/// This is a repository class for managing [D2TrackedEntity] entities.
///
/// This class provides methods for querying, manipulating,
/// and synchronizing [D2TrackedEntity] entities within the database.
class D2TrackedEntityRepository
    extends D2BaseTrackerDataRepository<D2TrackedEntity>
    with
        BaseTrackerDataDownloadServiceMixin<D2TrackedEntity>,
        TrackedEntityDataDownloadServiceMixin,
        D2BaseTrackerDataQueryMixin<D2TrackedEntity>,
        BaseTrackerDataUploadServiceMixin<D2TrackedEntity> {
  /// Constructs a new [D2TrackedEntityRepository] with the provided database and program.
  D2TrackedEntityRepository(super.db, {super.program});

  /// Stream controller for managing synchronization status updates.
  StreamController<D2SyncStatus> controller = StreamController<D2SyncStatus>();

  /// Retrieves a [D2TrackedEntity] by its UID [uid].
  ///
  /// - [uid] The UID of the tracked entity.
  ///
  /// Returns the [D2TrackedEntity] if found, otherwise null.
  @override
  D2TrackedEntity? getByUid(String uid) {
    Query<D2TrackedEntity> query =
        box.query(D2TrackedEntity_.uid.equals(uid)).build();
    return query.findFirst();
  }

  /// Retrieves all [D2TrackedEntity] entities.
  ///
  /// Returns a list of [D2TrackedEntity] entities.
  List<D2TrackedEntity>? getAll() {
    Query query = box.query().build();
    return query.find() as List<D2TrackedEntity>;
  }

  /// Maps a JSON object to a [D2TrackedEntity].
  ///
  /// - [json] The JSON object containing tracked entity data.
  ///
  /// Returns the [D2TrackedEntity] created from the JSON object.
  @override
  D2TrackedEntity mapper(Map<String, dynamic> json) {
    return D2TrackedEntity.fromMap(db, json);
  }

  /// The key used for uploading tracked entity data.
  @override
  String uploadDataKey = "trackedEntities";

  /// Retrieves a query for unsynced [D2TrackedEntity] entities.
  ///
  /// Returns a [Query] object for retrieving unsynced tracked entities.
  @override
  Query<D2TrackedEntity> getUnSyncedQuery() {
    return box.query(D2TrackedEntity_.synced.equals(false)).build();
  }

  /// Sets the program for the repository.
  ///
  /// - [program] The [D2Program] to be set.
  ///
  /// Returns the current instance of [D2TrackedEntityRepository].
  @override
  D2TrackedEntityRepository setProgram(D2Program program) {
    this.program = program;
    return this;
  }

  /// Adds program-specific conditions to the query.
  @override
  void addProgramToQuery() {
    if (queryBuilder == null || program == null) {
      return;
    }
    queryBuilder!.linkMany(D2TrackedEntity_.enrollmentsForQuery,
        D2Enrollment_.program.equals(program!.id));
  }

  /// Retrieves a query for deleted [D2TrackedEntity] entities.
  ///
  /// Returns a [Query] object for retrieving deleted tracked entities.
  @override
  Query<D2TrackedEntity> getDeletedQuery() {
    return box.query(D2TrackedEntity_.deleted.equals(true)).build();
  }
}
