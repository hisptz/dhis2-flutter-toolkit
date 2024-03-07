
import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/trackedEntityAttribute.dart';
import 'base.dart';
import 'trackedEntityAttributes.dart';
import 'trackedEntityType.dart';

@Entity()
class D2TrackedEntityTypeAttribute extends D2MetaResource {
  @override
  int id = 0;
  @override
  DateTime created;

  @override
  DateTime lastUpdated;

  @override
  String uid;

  final trackedEntityType = ToOne<D2TrackedEntityType>();
  final trackedEntityAttribute = ToOne<D2TrackedEntityAttribute>();

  String valueType;
  @override
  String? displayName;
  String displayShortName;
  bool mandatory;

  D2TrackedEntityTypeAttribute(
      this.id,
      this.displayName,
      this.created,
      this.lastUpdated,
      this.uid,
      this.valueType,
      this.displayShortName,
      this.mandatory);

  D2TrackedEntityTypeAttribute.fromMap(ObjectBox db, Map json)
      : created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"]),
        uid = json["id"],
        valueType = json["valueType"],
        displayName = json["displayName"],
        displayShortName = json["displayShortName"],
        mandatory = json["mandatory"] {
    id = D2TrackedEntityAttributeRepository(db).getIdByUid(json["id"]) ?? 0;
  }
}
