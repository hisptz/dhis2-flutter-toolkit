import 'package:objectbox/objectbox.dart';

@Entity()
class D2AppLog {
  int id = 0;
  DateTime timestamp;
  int code;
  String message;
  String process;
  String? stackTrace;

  D2AppLog(this.code, this.message, this.stackTrace, this.id, this.timestamp,
      this.process);

  D2AppLog.log(
      {required this.code,
      required this.message,
      required this.process,
      this.stackTrace})
      : timestamp = DateTime.now() {}
}
