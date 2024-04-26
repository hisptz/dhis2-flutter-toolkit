import '../../../objectbox.g.dart';
import '../../models/data/data_value_set.dart';
import 'base_aggregate.dart';
import 'query_mixin/base_aggregate_query_mixin.dart';

class D2DataValueSetRepository extends D2BaseAggregateRepository<D2DataValueSet>
    with D2BaseAggregateQueryMixin<D2DataValueSet> {
  D2DataValueSetRepository(super.db);

  @override
  D2DataValueSet? getByUid(String uid) {
    return box.query(D2DataValueSet_.uid.equals(uid)).build().findFirst();
  }

  int? getIdByUid(String uid) {
    return getByUid(uid)?.id;
  }

  @override
  D2DataValueSet mapper(Map<String, dynamic> json) {
    return D2DataValueSet.fromMap(db, json);
  }

  D2DataValueSetRepository byDataElement(int id) {
    queryConditions = D2DataValueSet_.dataElement.equals(id);
    return this;
  }

  Future<List<D2DataValueSet>?> getByDataElement(
      D2DataValueSet dataElement) async {
    queryConditions = D2DataValueSet_.dataElement.equals(dataElement.id);
    return query.findAsync();
  }

  @override
  Future<List<D2DataValueSet>> saveDataValueSets(
      List<D2DataValueSet> dataValueSets) async {
    return box.putAndGetManyAsync(dataValueSets);
  }
}
