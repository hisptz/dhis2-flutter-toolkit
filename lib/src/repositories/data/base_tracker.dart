import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/data/base.dart';
import 'package:objectbox/objectbox.dart';

/// This class provides methods and properties for managing tracker data.
abstract class D2BaseTrackerDataRepository<T extends D2DataResource>
    extends BaseDataRepository {
  /// The program associated with the tracker data.
  D2Program? program;

  /// Returns the Box instance associated with the repository.
  Box<T> get box {
    return db.store.box<T>();
  }

  /// Creates a new instance of [D2BaseTrackerDataRepository].
  ///
  /// - [super.db]: The ObjectBox database instance.
  /// - [program]: The program associated with the tracker data.
  D2BaseTrackerDataRepository(super.db, {this.program});

  /// Maps the JSON data to the tracker entity type [T].
  T mapper(Map<String, dynamic> json);

  /// Retrieves the ID of the entity with the given UID.
  int? getIdByUid(String uid) {
    return getByUid(uid)?.id;
  }

  /// Saves multiple entities to the database asynchronously.
  Future saveEntities(List<T> entities) {
    return box.putManyAsync(entities);
  }

  /// Saves a single entity to the database.
  int saveEntity(T entity) {
    return box.put(entity);
  }

  /// Sets the program associated with the repository.
  D2BaseTrackerDataRepository<T> setProgram(D2Program program);

  /// Sets the program associated with the repository using the program ID.
  ///
  /// Throws an exception if the program with the given ID does not exist.
  D2BaseTrackerDataRepository<T> setProgramFromId(String programId) {
    D2Program? program = D2ProgramRepository(db).getByUid(programId);

    if (program == null) {
      throw Exception("Program with id $programId does not exist");
    }
    setProgram(program);
    return this;
  }

  /// Retrieves an entity by its ID.
  T? getById(int id) {
    return box.get(id);
  }

  /// Retrieves an entity by its UID.
  T? getByUid(String uid);

  /// Saves multiple entities offline from JSON data.
  ///
  /// Returns the saved entities.
  Future<List<T>> saveOffline(List<Map<String, dynamic>> json) async {
    List<T> entities = json.map(mapper).toList();
    return box.putAndGetManyAsync(entities);
  }

  /// Deletes multiple entities from the database asynchronously.
  ///
  /// Returns the number of entities deleted.
  Future<int> deleteEntitiesAsync(List<T> entities) async {
    return box
        .removeManyAsync(entities.map<int>((entity) => entity.id).toList());
  }

  /// Deletes a single entity from the database.
  ///
  /// Whether the deletion was successful.
  bool deleteEntity(T entity) {
    return box.remove(entity.id);
  }

  /// Deletes multiple entities from the database.
  ///
  /// Returns the number of entities deleted.
  int deleteEntities(List<T> entities) {
    return box.removeMany(entities.map<int>((entity) => entity.id).toList());
  }
}
