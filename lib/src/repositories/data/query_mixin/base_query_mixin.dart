import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';

import '../../../../objectbox.g.dart';

mixin BaseQueryMixin<T extends D2DataResource> on BaseDataRepository<T> {
  QueryBuilder<T>? queryBuilder;

  Condition<T>? queryConditions;

  Query<T> get query {
    if (queryBuilder == null) {
      throw "You need to call initialize query first";
    }
    return queryBuilder!.build();
  }

  updateQueryCondition(Condition<T> condition) {
    if (queryConditions != null) {
      queryConditions!.and(condition);
    } else {
      queryConditions = condition;
    }
    return this;
  }

  List<T>? find() {
    return query.find();
  }

  Future<List<T>?> findAsync() async {
    return await query.findAsync();
  }

  void addProgramToQuery();

  BaseDataRepository<T> initializeQuery() {
    queryBuilder = box.query();
    addProgramToQuery();
    return this;
  }

  BaseDataRepository<T> clearQuery() {
    queryConditions = null;
    return this;
  }
}
