import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';

import '../../../objectbox.g.dart';
import 'base.dart';

class D2ProgramStageDataElementRepository
    extends BaseMetaRepository<D2ProgramStageDataElement> {
  D2ProgramStageDataElementRepository(super.db);

  @override
  D2ProgramStageDataElement? getByUid(String uid) {
    Query<D2ProgramStageDataElement> query =
        box.query(D2ProgramStageDataElement_.uid.equals(uid)).build();
    return query.findFirst();
  }

  @override
  Future<List<D2ProgramStageDataElement>> saveOffline(
    List<Map<String, dynamic>> json,
  ) async {
    //We need to delete existing programStageDataElements for the programStage in order to record them again
    String programStageUid = json.first["programStage"]["id"] as String;
    D2ProgramStage? programStage =
        D2ProgramStageRepository(db).getByUid(programStageUid);

    if (programStage != null) {
      List<D2ProgramStageDataElement> programStageDataElements = await box
          .query(
              D2ProgramStageDataElement_.programStage.equals(programStage.id))
          .build()
          .findAsync();

      List<int> programStageDataElementIds =
          programStageDataElements.map((element) => element.id).toList();

      if (programStageDataElements.isNotEmpty) {
        await box.removeManyAsync(programStageDataElementIds);
      }
    }

    return super.saveOffline(json);
  }

  @override
  D2ProgramStageDataElement mapper(Map<String, dynamic> json) {
    return D2ProgramStageDataElement.fromMap(db, json);
  }

  Future<void> deleteProgramStageDataElementsByProgram(String programId) async {
    D2Program? program = D2ProgramRepository(db).getByUid(programId);
    if (program != null) {
      List<int> programStages =
          program.programStages.map((stage) => stage.id).toList();
      for (int programStageId in programStages) {
        await box
            .query(
                D2ProgramStageDataElement_.programStage.equals(programStageId))
            .build()
            .removeAsync();
      }
    }
  }
}
