import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';

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

  List<Map> getAllLogsAsMap() {
    List<D2AppLog> logs = box.getAll();
    return logs.map((log) => log.toMap()).toList();
  }
}
