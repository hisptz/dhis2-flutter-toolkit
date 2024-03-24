import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/models/data/base_editable.dart';
import 'package:objectbox/objectbox.dart';

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

  D2DataValue.fromFormValues(this.value,
      {required D2Event event, required D2DataElement dataElement})
      : updatedAt = DateTime.now(),
        createdAt = DateTime.now(),
        uid = "${event.uid}-${dataElement.uid}",
        providedElsewhere = false {
    this.event.target = event;
    this.dataElement.target = dataElement;
  }

  @override
  bool synced = true;

  @override
  Future<Map<String, dynamic>> toMap({D2ObjectBox? db}) async {
    return {"dataElement": dataElement.target?.uid, "value": value};
  }

  @override
  Map<String, dynamic> toFormValues() {
    return {dataElement.target!.uid: value};
  }

  @override
  void updateFromFormValues(Map<String, dynamic> values,
      {required D2ObjectBox db, D2OrgUnit? orgUnit}) {
    String key = dataElement.target!.uid;
    if (values.containsKey(key)) {
      value = values[key];
      synced = false;
    }
  }

  @override
  void save(D2ObjectBox db) {
    D2DataValueRepository(db).saveEntity(this);
  }
}
