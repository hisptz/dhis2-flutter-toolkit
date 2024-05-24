import 'package:dhis2_flutter_toolkit/src/models/app/logs.dart';

import '../../../objectbox.dart';
import '../../../objectbox.g.dart';

class D2AppLogRepository {
  D2ObjectBox db;

  D2AppLogRepository(this.db);

  Box<D2AppLog> get box {
    return db.store.box<D2AppLog>();
  }

  List<D2AppLog> getLogsByProcess(String process) {
    return box.query(D2AppLog_.process.equals(process)).build().find();
  }
}
