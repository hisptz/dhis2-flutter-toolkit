import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class D2AppAutoSave extends D2DataResource {
  @override
  int id = 0;

  String data;

  final program = ToOne<D2Program>();

  final programStage = ToOne<D2ProgramStage>();

  final enrollment = ToOne<D2Enrollment>();

  final event = ToOne<D2Event>();

  D2AppAutoSave(this.id, this.data);

  D2AppAutoSave.fromMap(D2ObjectBox db, Map json) : data = json["data"] {
    if (json["program"] != null) {
      program.target =
          D2ProgramRepository(db).getByUid(json["program"].uid ?? "");

      if (json["enrollment"] != null) {
        id =
            D2AppAutoSaveRepository(db).getIdByEnrollment(json["enrollment"]) ??
                0;
        enrollment.target =
            D2EnrollmentRepository(db).getByUid(json["enrollment"].uid ?? "");
      } else {
        id = D2AppAutoSaveRepository(db).getIdByProgram(json["program"]) ?? 0;
      }
    }

    if (json["programStage"] != null) {
      programStage.target =
          D2ProgramStageRepository(db).getByUid(json["programStage"].uid ?? "");

      if (json["event"] != null) {
        id = D2AppAutoSaveRepository(db).getIdByEvent(json["event"]) ?? 0;
        event.target = D2EventRepository(db).getByUid(json["event"].uid ?? "");
      } else {
        id = D2AppAutoSaveRepository(db)
                .getIdByProgramStage(json["programStage"]) ??
            0;
      }
    }
  }

  @override
  DateTime createdAt = DateTime.now();

  @override
  DateTime updatedAt = DateTime.now();
}
