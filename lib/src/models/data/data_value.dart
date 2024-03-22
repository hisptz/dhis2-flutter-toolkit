import 'package:dhis2_flutter_toolkit/src/models/data/base_editable.dart';
import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import '../../repositories/data/data_value.dart';
import '../../repositories/data/event.dart';
import '../../repositories/metadata/data_element.dart';
import '../metadata/data_element.dart';
import 'base.dart';
import 'event.dart';
import 'upload_base.dart';

@Entity()
class D2DataValue extends D2DataResource
    implements SyncableData, D2BaseEditable {
  @override
  int id = 0;
  @override
  DateTime createdAt;
  @override
  DateTime updatedAt;

  @Unique()
  String uid;

  String? value;
  bool providedElsewhere;

  final event = ToOne<D2Event>();

  final dataElement = ToOne<D2DataElement>();

  D2DataValue(this.uid, this.id, this.createdAt, this.updatedAt, this.value,
      this.providedElsewhere, this.synced);

  D2DataValue.fromMap(D2ObjectBox db, Map json, String eventId)
      : updatedAt = DateTime.parse(json["updatedAt"]),
        createdAt = DateTime.parse(json["createdAt"]),
        uid = "$eventId-${json["dataElement"]}",
        value = json["value"],
        providedElsewhere = json["providedElsewhere"] {
    String uid = "$eventId-${json["dataElement"]}";
    id = D2DataValueRepository(db).getIdByUid(uid) ?? 0;

    event.target = D2EventRepository(db).getByUid(eventId);
    dataElement.target =
        D2DataElementRepository(db).getByUid(json["dataElement"]);
  }

  @override
  bool synced = true;

  @override
  Future<Map<String, dynamic>> toMap({D2ObjectBox? db}) async {
    return {"dataElement": dataElement.target?.uid, "value": value};
  }

  @override
  Map<String, dynamic> toFormValues() {
    return {uid: value};
  }
}
