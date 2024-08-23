import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/tracked_entity_attribute.dart';
import 'base.dart';
import 'tracked_entity_attribute.dart';
import 'tracked_entity_type.dart';

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

  D2TrackedEntityTypeAttribute.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json["created"] ?? json["createdAt"]),
        lastUpdated = DateTime.parse(json["lastUpdated"] ?? json["updatedAt"]),
        uid = json["id"],
        valueType = json["valueType"],
        displayName = json["displayName"],
        displayShortName = json["displayShortName"],
        mandatory = json["mandatory"] {
    id = D2TrackedEntityAttributeRepository(db).getIdByUid(json["id"]) ?? 0;
  }
}
