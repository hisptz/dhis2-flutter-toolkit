import 'package:dhis2_flutter_toolkit/src/models/metadata/program.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/data/query_mixin/base_tracker_query_mixin.dart';

import '../../../objectbox.g.dart';
import '../../models/data/data_value.dart';
import '../../models/data/event.dart';
import 'base_tracker.dart';

/// This class handles the repository functions for [D2DataValue] in the DHIS2 system.
class D2DataValueRepository extends D2BaseTrackerDataRepository<D2DataValue>
    with D2BaseTrackerDataQueryMixin<D2DataValue> {
  /// Constructs a new instance of [D2DataValueRepository].
  ///
  /// - [db] The database reference.
  D2DataValueRepository(super.db);

  /// Retrieves a [D2DataValue] by its UID.
  ///
  /// - [uid] The unique identifier of the data value.
  ///
  /// Returns the [D2DataValue] if found, otherwise null.
  @override
  D2DataValue? getByUid(String uid) {
    return box.query(D2DataValue_.uid.equals(uid)).build().findFirst();
  }

  /// Maps a JSON object to a [D2DataValue] instance.
  ///
  /// - [json] The JSON map containing data value information.
  ///
  /// Returns a [D2DataValue] object.
  @override
  D2DataValue mapper(Map<String, dynamic> json) {
    return D2DataValue.fromMap(db, json, "");
  }

  /// Filters the repository by event ID.
  ///
  /// - [id] The event ID to filter by.
  ///
  /// Returns the filtered [D2DataValueRepository].
  D2DataValueRepository byEvent(int id) {
    queryConditions = D2DataValue_.event.equals(id);
    return this;
  }

  /// Retrieves a list of [D2DataValue] by event asynchronously.
  ///
  /// - [event] The event to filter by.
  ///
  /// Returns a [Future] containing a list of [D2DataValue] objects.
  Future<List<D2DataValue>?> getByEvent(D2Event event) async {
    queryConditions = D2DataValue_.dataElement.equals(event.id);
    return query.findAsync();
  }

  /// Saves a list of [D2DataValue] entities asynchronously.
  ///
  /// - [entities] The list of data value entities to be saved.
  ///
  /// Returns a [Future] indicating the completion of the save operation.
  @override
  Future saveEntities(List<D2DataValue> entities) async {
    return box.putManyAsync(entities);
  }

  /// Sets the program for the repository.
  ///
  /// - [program] The program to be set.
  ///
  /// Returns the [D2BaseTrackerDataRepository] with the program set.
  @override
  D2BaseTrackerDataRepository<D2DataValue> setProgram(D2Program program) {
    this.program = program;
    return this;
  }

  /// Adds the program to the query conditions.
  @override
  void addProgramToQuery() {
    // TODO: implement addProgramToQuery
  }
}
