import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/objectbox.g.dart';

class D2AppAutoSaveRepository {
  D2ObjectBox db;

  Box<D2AppAutoSave> get box {
    return db.store.box<D2AppAutoSave>();
  }

  D2AppAutoSaveRepository(this.db);

  List<D2AppAutoSave>? getByProgram(D2Program program) {
    Query<D2AppAutoSave> query = box
        .query(D2AppAutoSave_.program
            .equals(program.id)
            .and(D2AppAutoSave_.enrollment.equals(0)))
        .build();
    return query.find();
  }

  List<D2AppAutoSave>? getByProgramStage(D2ProgramStage programStage) {
    Query<D2AppAutoSave> query = box
        .query(D2AppAutoSave_.programStage
            .equals(programStage.id)
            .and(D2AppAutoSave_.event.equals(0)))
        .build();
    return query.find();
  }

  List<D2AppAutoSave>? getByEnrollment(D2Enrollment enrollment) {
    Query<D2AppAutoSave> query =
        box.query(D2AppAutoSave_.enrollment.equals(enrollment.id)).build();
    return query.find();
  }

  List<D2AppAutoSave>? getByEvent(D2Event event) {
    Query<D2AppAutoSave> query =
        box.query(D2AppAutoSave_.event.equals(event.id)).build();
    return query.find();
  }

  int? getIdByProgram(D2Program program) {
    return getByProgram(program)?.firstOrNull?.id;
  }

  int? getIdByProgramStage(D2ProgramStage programStage) {
    return getByProgramStage(programStage)?.firstOrNull?.id;
  }

  int? getIdByEnrollment(D2Enrollment enrollment) {
    return getByEnrollment(enrollment)?.firstOrNull?.id;
  }

  int? getIdByEvent(D2Event event) {
    return getByEvent(event)?.firstOrNull?.id;
  }

  D2AppAutoSave mapper(Map<String, dynamic> json) {
    return D2AppAutoSave.fromMap(db, json);
  }

  Future<List<D2AppAutoSave>> saveOffline(
      List<Map<String, dynamic>> json) async {
    List<D2AppAutoSave> entities = json.map(mapper).toList();

    return box.putAndGetManyAsync(entities);
  }

  Future<int> deleteEntitiesAsync(List<D2AppAutoSave> entities) async {
    return box
        .removeManyAsync(entities.map<int>((entity) => entity.id).toList());
  }

  bool deleteEntity(D2AppAutoSave entity) {
    return box.remove(entity.id);
  }

  int deleteEntities(List<D2AppAutoSave> entities) {
    return box.removeMany(entities.map<int>((entity) => entity.id).toList());
  }
}
