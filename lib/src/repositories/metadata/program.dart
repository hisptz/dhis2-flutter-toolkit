import '../../../objectbox.g.dart';
import '../../models/metadata/program.dart';
import 'base.dart';
import 'download_mixins/base_meta_download_mixin.dart';
import 'download_mixins/program_download_mixin.dart';

class D2ProgramRepository extends BaseMetaRepository<D2Program>
    with
        BaseMetaDownloadServiceMixin<D2Program>,
        D2ProgramDownloadServiceMixin {
  D2ProgramRepository(super.db);

  @override
  D2Program? getByUid(String uid) {
    Query<D2Program> query = box.query(D2Program_.uid.equals(uid)).build();
    return query.findFirst();
  }

  @override
  D2Program mapper(Map<String, dynamic> json) {
    return D2Program.fromMap(db, json);
  }

  // @override
  // Future<List<D2Program>> saveOffline(List<Map<String, dynamic>> json) async {
  //   List<D2Program> entities = json.map(mapper).toList();
  //   List<D2Program> savedEntities = await box.putAndGetManyAsync(entities);
  //   List<D2Sharing> sharing = savedEntities.map((savedProgram) {
  //     Map<String, dynamic> programObject =
  //         json.firstWhere((programObj) => programObj['id'] == savedProgram.uid);
  //     Map<String, dynamic> sharingObject = programObject['sharing'];
  //     return D2Sharing.fromMap(sharingObject, program: savedProgram);
  //   }).toList();
  // }

  D2ProgramRepository byIdentifiableToken(String keyword) {
    queryConditions = D2Program_.uid
        .equals(keyword)
        .or(D2Program_.name.contains(keyword, caseSensitive: false))
        .or(D2Program_.shortName.contains(keyword, caseSensitive: false));
    return this;
  }
}
