import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import '../../repositories/metadata/tracked_entity_attribute.dart';
import '../metadata/org_unit.dart';
import '../metadata/tracked_entity_attribute.dart';

@Entity()
class D2ReservedValue {
  int id = 0;
  final trackedEntityAttribute = ToOne<D2TrackedEntityAttribute>();
  final orgUnit = ToOne<D2OrgUnit>();

  String value;
  String owner;

  bool assigned;

  DateTime createdOn;
  DateTime expiresOn;

  D2ReservedValue(this.value, this.assigned, this.id, this.createdOn,
      this.expiresOn, this.owner);

  D2ReservedValue.fromMap(D2ObjectBox db, Map json, {D2OrgUnit? orgUnit})
      : value = json["value"],
        createdOn = DateTime.parse(json["created"]),
        expiresOn = DateTime.parse(json["expiryDate"]),
        assigned = false,
        owner = json["ownerObject"] {
    this.orgUnit.target = orgUnit;
    if (owner == "TRACKEDENTITYATTRIBUTE") {
      trackedEntityAttribute.target =
          D2TrackedEntityAttributeRepository(db).getByUid(json["ownerUid"]);
    }
  }
}
