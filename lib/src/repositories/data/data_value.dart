import 'package:dhis2_flutter_toolkit/src/models/metadata/program.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/data/query_mixin/base_query_mixin.dart';

import '../../../objectbox.g.dart';
import '../../models/data/data_value.dart';
import '../../models/data/event.dart';
import 'base.dart';

class D2DataValueRepository extends BaseDataRepository<D2DataValue>
    with BaseQueryMixin<D2DataValue> {
  D2DataValueRepository(super.db);

  @override
  D2DataValue? getByUid(String uid) {
    return box.query(D2DataValue_.uid.equals(uid)).build().findFirst();
  }

  @override
  D2DataValue mapper(Map<String, dynamic> json) {
    return D2DataValue.fromMap(db, json, "");
  }

  D2DataValueRepository byEvent(int id) {
    queryConditions = D2DataValue_.event.equals(id);
    return this;
  }

  Future<List<D2DataValue>?> getByEvent(D2Event event) async {
    queryConditions = D2DataValue_.dataElement.equals(event.id);
    return query?.findAsync();
  }

  @override
  Future saveEntities(List<D2DataValue> entities) async {
    return box.putManyAsync(entities);
  }

  @override
  BaseDataRepository<D2DataValue> setProgram(D2Program program) {
    this.program = program;
    return this;
  }

  @override
  void addProgramToQuery() {
    // TODO: implement addProgramToQuery
  }
}
