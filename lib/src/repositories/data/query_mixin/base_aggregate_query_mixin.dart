import '../../../../objectbox.g.dart';
import '../../../models/data/base.dart';
import '../base_aggregate.dart';

mixin D2BaseAggregateQueryMixin<T extends D2DataResource>
    on D2BaseAggregateRepository<T> {
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

  D2BaseAggregateRepository<T> initializeQuery() {
    queryBuilder = box.query();
    return this;
  }

  D2BaseAggregateRepository<T> clearQuery() {
    queryConditions = null;
    return this;
  }
}
