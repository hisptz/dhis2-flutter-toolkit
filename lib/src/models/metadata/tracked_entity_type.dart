import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/tracked_entity_type.dart';
import 'base.dart';
import 'tracked_entity_type_attribute.dart';

@Entity()
class D2TrackedEntityType extends D2MetaResource {
  @override
  int id = 0;
  @override
  DateTime created;

  @override
  DateTime lastUpdated;

  @override
  @Unique()
  String uid;

  String name;
  String? description;

  final trackedEntityTypeAttributes = ToMany<D2TrackedEntityTypeAttribute>();

  D2TrackedEntityType(this.id, this.displayName, this.created, this.lastUpdated,
      this.uid, this.name, this.description);

  D2TrackedEntityType.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json["created"] ?? json["createdAt"]),
        lastUpdated = DateTime.parse(json["lastUpdated"] ?? json["updatedAt"]),
        uid = json["id"],
        name = json["name"],
        description = json["description"],
        displayName = json["displayName"] {
    id = D2TrackedEntityTypeRepository(db).getIdByUid(json["id"]) ?? 0;
  }

  @override
  String? displayName;
}
