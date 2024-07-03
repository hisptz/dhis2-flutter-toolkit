import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class D2AppAutoSave extends D2DataResource {
  @override
  int id = 0;

  String data;

  final program = ToOne<D2Program>();

  final programStage = ToOne<D2ProgramStage>();

  D2AppAutoSave(this.id, this.data);

  D2AppAutoSave.fromMap(D2ObjectBox db, Map json) : data = json["data"] {
    id = D2AppAutoSaveRepository(db).getIdByProgram(json["program"]) ?? 0;

    if (json["program"] != null) {
      program.target =
          D2ProgramRepository(db).getByUid(json["program"].uid ?? "");
    }

    if (json["programStage"] != null) {
      programStage.target =
          D2ProgramStageRepository(db).getByUid(json["programStage"].uid ?? "");
    }
  }

  @override
  DateTime createdAt = DateTime.now();

  @override
  DateTime updatedAt = DateTime.now();
}
