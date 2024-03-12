import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:objectbox/objectbox.dart';

abstract class BaseDataRepository<T extends D2DataResource> {
  D2ObjectBox db;
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

  updateQueryCondition(Condition<T> condition) {
    if (queryConditions != null) {
      queryConditions!.and(condition);
    } else {
      queryConditions = condition;
    }
  }

  BaseDataRepository<T> setProgram(D2Program program);

  BaseDataRepository<T> setProgramFromId(String programId) {
    D2Program? program = D2ProgramRepository(db).getByUid(programId);

    if (program == null) {
      throw "Program with id $programId does not exist";
    }
    setProgram(program);
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
