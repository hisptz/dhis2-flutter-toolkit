import '../../../objectbox.g.dart';
import '../../models/metadata/entry.dart';
import 'base.dart';
import 'entry.dart';

class D2ProgramStageSectionRepository
    extends BaseMetaRepository<D2ProgramStageSection> {
  D2ProgramStageSectionRepository(super.db);

  @override
  D2ProgramStageSection? getByUid(String uid) {
    Query<D2ProgramStageSection> query =
        box.query(D2ProgramStageSection_.uid.equals(uid)).build();
    return query.findFirst();
  }

  @override
  D2ProgramStageSection mapper(Map<String, dynamic> json) {
    return D2ProgramStageSection.fromMap(db, json);
  }

  @override
  Future<List<D2ProgramStageSection>> saveOffline(
      List<Map<String, dynamic>> json) {
    String programStageUid = json.first["programStage"]["id"] as String;
    D2ProgramStage? programStage =
        D2ProgramStageRepository(db).getByUid(programStageUid);

    if (programStage != null) {
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
