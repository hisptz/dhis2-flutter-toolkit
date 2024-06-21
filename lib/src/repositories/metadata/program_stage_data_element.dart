import '../../../objectbox.g.dart';

import '../../models/metadata/program_stage_data_element.dart';
import 'base.dart';

/// This is a repository class for managing [D2ProgramStageDataElement] instances.
///
/// This repository provides methods to retrieve and map [D2ProgramStageDataElement]
/// instances from the database, as well as other operations specific to this entity.
class D2ProgramStageDataElementRepository
    extends BaseMetaRepository<D2ProgramStageDataElement> {
  /// Creates a new instance of [D2ProgramStageDataElementRepository].
  ///
  /// - [db] is the database instance.
  D2ProgramStageDataElementRepository(super.db);

  /// Retrieves a [D2ProgramStageDataElement] by its UID [uid].
  ///
  /// - [uid] is the UID of the data element to retrieve.
  ///
  /// Returns the [D2ProgramStageDataElement] with the specified UID, or `null` if not found.
  @override
  D2ProgramStageDataElement? getByUid(String uid) {
    Query<D2ProgramStageDataElement> query =
        box.query(D2ProgramStageDataElement_.uid.equals(uid)).build();
    return query.findFirst();
  }

  /// Maps a JSON object to a [D2ProgramStageDataElement] instance.
  ///
  /// - [json] is the map containing the data to initialize the instance.
  ///
  /// Returns a new [D2ProgramStageDataElement] instance initialized with the data from [json].
  @override
  D2ProgramStageDataElement mapper(Map<String, dynamic> json) {
    return D2ProgramStageDataElement.fromMap(db, json);
  }
}
