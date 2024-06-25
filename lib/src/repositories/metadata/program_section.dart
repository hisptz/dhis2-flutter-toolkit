import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/objectbox.g.dart';

import 'base.dart';

/// This is a repository class for handling operations related to [D2ProgramSection].
///
/// This repository provides methods to query, map, and save [D2ProgramSection] objects.
class D2ProgramSectionRepository extends BaseMetaRepository<D2ProgramSection> {
  /// Constructs a [D2ProgramSectionRepository] instance with the given database.
  ///
  /// - [db] The [D2ObjectBox] instance used for repository operations.
  D2ProgramSectionRepository(super.db);

  /// Retrieves a [D2ProgramSection] by its unique identifier (UID) [uid].
  ///
  /// - [uid] The unique identifier of the program section.
  ///
  /// Returns a [D2ProgramSection] instance if found, otherwise `null`.
  @override
  D2ProgramSection? getByUid(String uid) {
    Query<D2ProgramSection> query =
        box.query(D2ProgramSection_.uid.equals(uid)).build();
    return query.findFirst();
  }

  /// Maps a JSON object [json] to a [D2ProgramSection] instance.
  ///
  /// - [json] The JSON object containing the program section data.
  ///
  /// Returns a [D2ProgramSection] instance created from the JSON data.
  @override
  D2ProgramSection mapper(Map<String, dynamic> json) {
    return D2ProgramSection.fromMap(db, json);
  }

  /// Saves a list of [D2ProgramSection] objects offline.
  ///
  /// This method first deletes existing sections for the program before saving the new data.
  ///
  /// - [json] A list of JSON objects representing the program sections to be saved.
  ///
  /// Returns a [Future] containing a list of saved [D2ProgramSection] instances.
  @override
  Future<List<D2ProgramSection>> saveOffline(List<Map<String, dynamic>> json) {
    //We need to delete existing sections for the program in order to record them again
    String programUid = json.first["program"]["id"] as String;
    D2Program? program = D2ProgramRepository(db).getByUid(programUid);

    if (program != null) {
      List<int> sectionIds = box
          .query(D2ProgramSection_.program.equals(program.id))
          .build()
          .findIds();

      if (sectionIds.isNotEmpty) {
        box.removeMany(sectionIds);
      }
    }

    return super.saveOffline(json);
  }
}
