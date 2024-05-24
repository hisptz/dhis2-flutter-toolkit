import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/objectbox.g.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/data/base.dart';

import '../../models/data/entry.dart';

class D2ImportSummaryErrorRepository extends BaseDataRepository {
  D2ImportSummaryErrorRepository(super.db);

  Box<D2ImportSummaryError> get box {
    return db.store.box<D2ImportSummaryError>();
  }

  D2ImportSummaryError? getByUid(String uid) {
    return box.query(D2ImportSummaryError_.uid.equals(uid)).build().findFirst();
  }

  int? getIdByUid(String uid) {
    return getByUid(uid)?.id;
  }

  D2ImportSummaryError? getById(int id) {
    return box.get(id);
  }

  Future saveEntities(List<D2ImportSummaryError> entities) {
    return box.putManyAsync(entities);
  }

  Future<List<D2ImportSummaryError>> saveOffline(
      List<Map<String, dynamic>> json) async {
    List<D2ImportSummaryError> entities = json
        .map<D2ImportSummaryError>(
            (Map entity) => D2ImportSummaryError.fromMap(db, entity))
        .toList();
    return box.putAndGetManyAsync(entities);
  }
}
