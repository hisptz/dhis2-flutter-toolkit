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

  int? getIdByUid(String uid) {
    return getByUid(uid)?.id;
  }

  Future saveEntities(List<T> entities) {
    return box.putManyAsync(entities);
  }

  int saveEntity(T entity) {
    return box.put(entity);
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

  T? getById(int id) {
    return box.get(id);
  }

  T? getByUid(String uid);

  Future<List<T>> saveOffline(List<Map<String, dynamic>> json) async {
    List<T> entities = json.map(mapper).toList();
    return box.putAndGetManyAsync(entities);
  }
}
