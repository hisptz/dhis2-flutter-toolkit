import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import '../../models/metadata/base.dart';

abstract class BaseMetaRepository<T extends D2MetaResource> {
  D2ObjectBox db;

  Box<T> get box {
    return db.store.box<T>();
  }

  BaseMetaRepository(this.db);

  T mapper(Map<String, dynamic> json);

  Condition<T>? queryConditions;

  int? getIdByUid(String uid) {
    return getByUid(uid)?.id;
  }

  QueryBuilder<T> get queryBuilder {
    return box.query(queryConditions);
  }

  Query<T> get query {
    return queryBuilder.build();
  }

  Future saveEntities(List<T> entities) {
    return box.putManyAsync(entities);
  }

  List<T> find() {
    return query.find();
  }

  Future<List<T>> findAsync() async {
    return await query.findAsync();
  }

  T? getById(int id) {
    return box.get(id);
  }

  T? getByUid(String uid);

  Future<List<T>> saveOffline(List<Map<String, dynamic>> json) async {
    List<T> entities = json.map(mapper).toList();
    return box.putAndGetManyAsync(entities);
  }

  BaseMetaRepository<T> clearQuery() {
    queryConditions = null;
    return this;
  }
}
