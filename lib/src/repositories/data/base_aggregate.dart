import 'package:objectbox/objectbox.dart';

import '../../models/data/base.dart';
import 'base.dart';

abstract class D2BaseAggregateRepository<T extends D2DataResource>
    extends BaseDataRepository {
  Box<T> get box {
    return db.store.box<T>();
  }

  D2BaseAggregateRepository(super.db);

  T mapper(Map<String, dynamic> json);

  Future saveDataValueSets(List<T> dataValueSets) {
    return box.putManyAsync(dataValueSets);
  }

  int saveDataValueSet(T dataValueSet) {
    return box.put(dataValueSet);
  }

  T? getById(int id) {
    return box.get(id);
  }

  T? getByUid(String uid);

  Future<List<T>> saveOffline(List<Map<String, dynamic>> json) async {
    List<T> dataValueSets = json.map(mapper).toList();
    return box.putAndGetManyAsync(dataValueSets);
  }
}
