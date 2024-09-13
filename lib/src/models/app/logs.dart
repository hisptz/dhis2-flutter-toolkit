import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class D2AppLog {
  int id = 0;

  DateTime timestamp;
  int code;
  @Unique()
  String uid;
  String message;
  String process;
  String? stackTrace;

  D2AppLog(this.code, this.message, this.stackTrace, this.id, this.timestamp,
      this.process, this.uid);

  D2AppLog.log(
      {required this.code,
      required this.message,
      required this.process,
      this.stackTrace})
      : timestamp = DateTime.now(),
        uid = D2UID.generate();

  Map<String, dynamic> toMap() {
    return {
      'id': uid,
      'timestamp': timestamp.toIso8601String(),
      'code': code,
      'message': message,
      'process': process,
      'stackTrace': stackTrace,
    };
  }

  D2AppLog? save(D2ObjectBox db) {
    D2AppLogRepository(db).save(this);
    return D2AppLogRepository(db).getByUid(uid);
  }
}
