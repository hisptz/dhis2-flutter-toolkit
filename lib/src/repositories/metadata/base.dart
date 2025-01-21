import 'package:dhis2_flutter_toolkit/src/utils/chunk.dart';
import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import '../../models/metadata/base.dart';

int PAGINATION = 1000;

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
    if (json.length > PAGINATION) {
      //We need to chunk this into groups of 2000
      List<List<Map<String, dynamic>>> chunks =
          ChunkUtil.chunkItems<Map<String, dynamic>>(
              items: json, size: PAGINATION);
      List<int> ids = [];
      for (List<Map<String, dynamic>> chunk in chunks) {
        ids.addAll(await box.putManyAsync(chunk.map(mapper).toList()));
      }
      return box.getManyAsync(ids).then((value) =>
          value.where((entity) => entity != null).cast<T>().toList());
    } else {
      List<T> entities = json.map(mapper).toList();
      List<int> ids = await box.putManyAsync(entities);
      return box.getManyAsync(ids).then((value) =>
          value.where((entity) => entity != null).cast<T>().toList());
    }
  }

  BaseMetaRepository<T> clearQuery() {
    queryConditions = null;
    return this;
  }
}
