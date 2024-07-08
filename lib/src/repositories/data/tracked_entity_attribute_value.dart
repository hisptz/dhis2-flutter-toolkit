import 'package:dhis2_flutter_toolkit/src/models/metadata/program.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/data/query_mixin/base_tracker_query_mixin.dart';

import '../../../objectbox.g.dart';
import '../../models/data/tracked_entity_attribute_value.dart';
import 'base_tracker.dart';

/// This is a repository class for managing [D2TrackedEntityAttributeValue] entities.
///
/// This class provides methods for querying and manipulating
/// [D2TrackedEntityAttributeValue] entities within the database.
class D2TrackedEntityAttributeValueRepository
    extends D2BaseTrackerDataRepository<D2TrackedEntityAttributeValue>
    with D2BaseTrackerDataQueryMixin<D2TrackedEntityAttributeValue> {
  /// Constructs a new [D2TrackedEntityAttributeValueRepository] with the provided database.
  D2TrackedEntityAttributeValueRepository(super.db);

  /// Retrieves a [D2TrackedEntityAttributeValue] by its ID [id].
  ///
  /// - [id] The ID of the tracked entity attribute value.
  ///
  /// Returns the [D2TrackedEntityAttributeValue] if found, otherwise null.
  @override
  D2TrackedEntityAttributeValue? getById(int id) {
    Query<D2TrackedEntityAttributeValue> query = box
        .query(D2TrackedEntityAttributeValue_.trackedEntityAttribute.equals(id))
        .build();
    return query.findFirst();
  }

  /// Filters the repository by tracked entity ID [id].
  ///
  /// - [id] The ID of the tracked entity.
  ///
  /// Returns the current instance of [D2TrackedEntityAttributeValueRepository].
  D2TrackedEntityAttributeValueRepository byTrackedEntity(int id) {
    queryConditions = D2TrackedEntityAttributeValue_.trackedEntity.equals(id);
    return this;
  }

  /// Retrieves a [D2TrackedEntityAttributeValue] by its UID [uid].
  ///
  /// - [uid] The UID of the tracked entity attribute value.
  ///
  /// Returns the [D2TrackedEntityAttributeValue] if found, otherwise null.
  @override
  D2TrackedEntityAttributeValue? getByUid(String uid) {
    return box
        .query(D2TrackedEntityAttributeValue_.uid.equals(uid))
        .build()
        .findFirst();
  }

  /// Maps a JSON object to a [D2TrackedEntityAttributeValue].
  ///
  /// - [json] The JSON object containing attribute value data.
  ///
  /// Returns the [D2TrackedEntityAttributeValue] created from the JSON object.
  @override
  D2TrackedEntityAttributeValue mapper(Map<String, dynamic> json) {
    return D2TrackedEntityAttributeValue.fromMap(db, json, "");
  }

  /// Sets the program for the repository.
  ///
  /// - [program] The [D2Program] to be set.
  ///
  /// Returns the current instance of [D2BaseTrackerDataRepository].
  @override
  D2BaseTrackerDataRepository<D2TrackedEntityAttributeValue> setProgram(
      D2Program program) {
    this.program = program;
    return this;
  }

  @override
  void addProgramToQuery() {
    // TODO: implement addProgramToQuery
  }
}
