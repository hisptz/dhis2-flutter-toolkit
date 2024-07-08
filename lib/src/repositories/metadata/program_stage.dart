import '../../../objectbox.g.dart';

import '../../models/metadata/program_stage.dart';
import 'base.dart';

/// This is a repository class for managing [D2ProgramStage] instances.
///
/// This repository provides methods to retrieve and map [D2ProgramStage]
/// instances from a database, as well as other operations specific to this entity.
class D2ProgramStageRepository extends BaseMetaRepository<D2ProgramStage> {
  /// Creates a new instance of [D2ProgramStageRepository].
  ///
  /// - [db] is the database instance.
  D2ProgramStageRepository(super.db);

  /// Retrieves a [D2ProgramStage] by its UID [uid].
  ///
  /// - [uid] is the UID of the program stage to retrieve.
  ///
  /// Returns the [D2ProgramStage] with the specified UID, or `null` if not found.
  @override
  D2ProgramStage? getByUid(String uid) {
    Query<D2ProgramStage> query =
        box.query(D2ProgramStage_.uid.equals(uid)).build();
    return query.findFirst();
  }

  /// Maps a JSON object to a [D2ProgramStage] instance.
  ///
  /// - [json] is the map containing the data to initialize the instance.
  ///
  /// Returns a new [D2ProgramStage] instance initialized with the data from [json].
  @override
  D2ProgramStage mapper(Map<String, dynamic> json) {
    return D2ProgramStage.fromMap(db, json);
  }

  /// Filters the repository by a specific program ID.
  ///
  /// - [programId] is the ID of the program to filter by.
  ///
  /// Returns the current instance of [D2ProgramStageRepository] with the applied filter.
  D2ProgramStageRepository byProgram(int programId) {
    queryConditions = D2ProgramStage_.program.equals(programId);
    return this;
  }
}
