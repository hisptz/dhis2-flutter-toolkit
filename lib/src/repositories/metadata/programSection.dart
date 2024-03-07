import 'package:dhis2_flutter_toolkit/objectbox.g.dart';
import '../../../objectbox.g.dart';

import '../../models/metadata/programSection.dart';
import 'base.dart';

class D2ProgramSectionRepository extends BaseMetaRepository<D2ProgramSection> {
  D2ProgramSectionRepository(super.db);

  @override
  D2ProgramSection? getByUid(String uid) {
    Query<D2ProgramSection> query =
        box.query(D2ProgramSection_.uid.equals(uid)).build();
    return query.findFirst();
  }

  @override
  D2ProgramSection mapper(Map<String, dynamic> json) {
    return D2ProgramSection.fromMap(db, json);
  }
}
