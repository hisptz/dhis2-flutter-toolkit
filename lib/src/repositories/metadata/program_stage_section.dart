import '../../../objectbox.g.dart';
import '../../models/metadata/entry.dart';
import 'base.dart';
import 'entry.dart';

/// This is a repository class for managing [D2ProgramStageSection] entities.
///
/// This repository provides methods such as retrieving, mapping, and
/// saving data.
class D2ProgramStageSectionRepository
    extends BaseMetaRepository<D2ProgramStageSection> {
  /// Creates a new instance of [D2ProgramStageSectionRepository].
  ///
  /// - [db] is the database instance.
  D2ProgramStageSectionRepository(super.db);

  /// Retrieves a [D2ProgramStageSection] by its unique identifier [uid].
  ///
  /// - [uid] is the unique identifier of the program stage section.
  ///
  /// Returns the [D2ProgramStageSection] with the specified UID, or null if not found.
  @override
  D2ProgramStageSection? getByUid(String uid) {
    Query<D2ProgramStageSection> query =
        box.query(D2ProgramStageSection_.uid.equals(uid)).build();
    return query.findFirst();
  }

  /// Maps a JSON object to a [D2ProgramStageSection] instance.
  ///
  /// - [json] is the map containing the data to initialize the instance.
  ///
  /// Returns a new instance of [D2ProgramStageSection] initialized with the provided data.
  @override
  D2ProgramStageSection mapper(Map<String, dynamic> json) {
    return D2ProgramStageSection.fromMap(db, json);
  }

  /// Saves a list of [D2ProgramStageSection] entities offline.
  ///
  /// - [json] is the list of maps containing the data to be saved.
  ///
  /// This method first deletes existing sections for the associated program stage
  /// before saving the new data.
  ///
  /// Returns a future that completes with the list of saved [D2ProgramStageSection] entities.
  @override
  Future<List<D2ProgramStageSection>> saveOffline(
      List<Map<String, dynamic>> json) {
    // Extract the program stage UID from the first JSON object.
    String programStageUid = json.first["programStage"]["id"] as String;
    D2ProgramStage? programStage =
        D2ProgramStageRepository(db).getByUid(programStageUid);

    if (programStage != null) {
      // Find and remove existing sections for the program stage.
      List<int> sectionIds = box
          .query(D2ProgramStageSection_.programStage.equals(programStage.id))
          .build()
          .findIds();

      if (sectionIds.isNotEmpty) {
        box.removeMany(sectionIds);
      }
    }

    return super.saveOffline(json);
  }
}
