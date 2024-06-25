import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/objectbox.g.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/data/base.dart';

import '../../models/data/entry.dart';

/// This class handles the repository functions for managing [D2ImportSummaryError] entities.
class D2ImportSummaryErrorRepository extends BaseDataRepository {
  /// Constructs a [D2ImportSummaryErrorRepository] with the given [db].
  D2ImportSummaryErrorRepository(super.db);

  /// Returns the Box for [D2ImportSummaryError] entities.
  Box<D2ImportSummaryError> get box {
    return db.store.box<D2ImportSummaryError>();
  }

  /// Retrieves a [D2ImportSummaryError] by its unique identifier [uid].
  ///
  /// Returns the matching [D2ImportSummaryError] or null if not found.
  D2ImportSummaryError? getByUid(String uid) {
    return box.query(D2ImportSummaryError_.uid.equals(uid)).build().findFirst();
  }

  /// Retrieves the ID of a [D2ImportSummaryError] by its unique identifier [uid].
  ///
  /// Returns the ID of the matching [D2ImportSummaryError] or null if not found.
  int? getIdByUid(String uid) {
    return getByUid(uid)?.id;
  }

  /// Retrieves a [D2ImportSummaryError] by its ID [id].
  ///
  /// Returns the matching [D2ImportSummaryError] or null if not found.
  D2ImportSummaryError? getById(int id) {
    return box.get(id);
  }

  /// Saves a list of [D2ImportSummaryError] entities.
  ///
  /// - [entities] The list of entities to save.
  /// - Returns a [Future] that completes when the operation is done.
  Future saveEntities(List<D2ImportSummaryError> entities) {
    return box.putManyAsync(entities);
  }

  /// Clears all [D2ImportSummaryError] entities from the repository.
  ///
  /// Returns a [Future] that completes when the operation is done.
  Future clearErrors() async {
    return box.removeAllAsync();
  }

  /// Saves a list of [D2ImportSummaryError] entities from JSON data.
  ///
  /// - [json] The list of JSON maps representing the entities to save.
  /// - Returns a [Future] with the list of saved [D2ImportSummaryError] entities.
  Future<List<D2ImportSummaryError>> saveOffline(
      List<Map<String, dynamic>> json) async {
    List<D2ImportSummaryError> entities = json
        .map<D2ImportSummaryError>(
            (Map entity) => D2ImportSummaryError.fromMap(db, entity))
        .toList();
    return box.putAndGetManyAsync(entities);
  }
}
