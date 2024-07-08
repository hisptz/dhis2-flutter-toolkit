import 'package:dhis2_flutter_toolkit/src/models/metadata/program.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/data/query_mixin/base_tracker_query_mixin.dart';

import '../../../objectbox.g.dart';
import '../../models/data/relationship.dart';
import 'base_tracker.dart';
import 'upload_mixin/base_tracker_data_upload_service_mixin.dart';

/// This is a repository class for managing [D2Relationship] entities.
class D2RelationshipRepository
    extends D2BaseTrackerDataRepository<D2Relationship>
    with
        D2BaseTrackerDataQueryMixin<D2Relationship>,
        BaseTrackerDataUploadServiceMixin<D2Relationship> {
  /// Constructs a [D2RelationshipRepository] with the given database.
  D2RelationshipRepository(super.db, {super.program});

  /// Retrieves a [D2Relationship] entity by its unique identifier [uid].
  ///
  /// - [uid] is the unique identifier of the relationship.
  ///
  /// Returns the [D2Relationship] entity if found, or null if not found.
  @override
  D2Relationship? getByUid(String uid) {
    Query<D2Relationship> query =
        box.query(D2Relationship_.uid.equals(uid)).build();
    return query.findFirst();
  }

  /// Maps a JSON [Map] to a [D2Relationship] entity.
  ///
  /// - [json] is the JSON map containing the relationship data.
  ///
  /// Returns the [D2Relationship] entity.
  @override
  D2Relationship mapper(Map<String, dynamic> json) {
    return D2Relationship.fromMap(db, json);
  }

  /// The label for the repository, used for display purposes.
  @override
  String label = "Relationships";

  /// The key used for uploading data.
  @override
  String uploadDataKey = "relationships";

  /// Retrieves a query for unsynced [D2Relationship] entities.
  ///
  /// Returns a [Query] object for unsynced relationships.
  @override
  Query<D2Relationship> getUnSyncedQuery() {
    return box.query(D2Relationship_.synced.equals(false)).build();
  }

  /// Sets the program context for the repository.
  ///
  /// - [program] is the [D2Program] to set.
  ///
  /// Returns the updated repository.
  @override
  D2BaseTrackerDataRepository<D2Relationship> setProgram(D2Program program) {
    this.program = program;
    return this;
  }

  /// Adds the current program to the query.
  @override
  void addProgramToQuery() {
    // TODO: implement addProgramToQuery
  }

  /// Retrieves a query for deleted [D2Relationship] entities.
  ///
  /// Returns a [Query] object for deleted relationships.
  @override
  Query<D2Relationship> getDeletedQuery() {
    return box.query(D2Relationship_.deleted.equals(true)).build();
  }
}
