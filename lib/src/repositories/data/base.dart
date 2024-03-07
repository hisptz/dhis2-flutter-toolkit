
import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../models/data/base.dart';
import '../../models/metadata/program.dart';

abstract class BaseDataRepository<T extends D2DataResource> {
  ObjectBox db;
  D2Program? program;

  Box<T> get box {
    return db.store.box<T>();
  }

  BaseDataRepository(this.db, {this.program});

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

  BaseDataRepository<T> setProgram(D2Program program) {
    this.program = program;
    return this;
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

  BaseDataRepository<T> clearQuery() {
    queryConditions = null;
    return this;
  }
}
