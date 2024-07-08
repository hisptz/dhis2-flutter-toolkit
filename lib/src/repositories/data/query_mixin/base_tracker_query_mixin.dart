import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';

import '../../../../objectbox.g.dart';

/// Mixin providing query capabilities for tracker data repositories.
///
/// This mixin is intended to be used on classes that extend [D2BaseTrackerDataRepository].
mixin D2BaseTrackerDataQueryMixin<T extends D2DataResource>
    on D2BaseTrackerDataRepository<T> {
  /// The query builder for creating queries.
  QueryBuilder<T>? queryBuilder;

  /// The conditions to be applied to the query.
  Condition<T>? queryConditions;

  /// Retrieves the query built by the query builder.
  ///
  /// Throws an exception if the query builder is not initialized.
  Query<T> get query {
    if (queryBuilder == null) {
      throw "You need to call initialize query first";
    }
    return queryBuilder!.build();
  }

  /// Updates the query conditions with the given [condition].
  ///
  /// If there are existing conditions, the new condition is combined with them.
  /// Otherwise, the new condition is set as the current condition.
  /// Returns the current instance of the mixin.
  updateQueryCondition(Condition<T> condition) {
    if (queryConditions != null) {
      queryConditions!.and(condition);
    } else {
      queryConditions = condition;
    }
    return this;
  }

  /// Finds and returns the list of items matching the current query conditions.
  ///
  /// Returns a list of matching items or `null` if no items match.
  List<T>? find() {
    return query.find();
  }

  /// Asynchronously finds and returns the list of items matching the current query conditions.
  ///
  /// Returns a [Future] that completes with the list of matching items or `null` if no items match.
  Future<List<T>?> findAsync() async {
    return await query.findAsync();
  }

  void addProgramToQuery();

  /// Initializes the query builder and adds program-specific conditions to the query.
  ///
  /// Returns the current instance of the repository.
  D2BaseTrackerDataRepository<T> initializeQuery() {
    queryBuilder = box.query();
    addProgramToQuery();
    return this;
  }

  /// Clears the current query conditions.
  ///
  /// Returns the current instance of the repository.
  D2BaseTrackerDataRepository<T> clearQuery() {
    queryConditions = null;
    return this;
  }
}
