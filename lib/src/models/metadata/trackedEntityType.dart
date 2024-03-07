import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/trackedEntityType.dart';
import 'base.dart';
import 'trackedEntityTypeAttribute.dart';

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

  D2TrackedEntityType.fromMap(ObjectBox db, Map json)
      : created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"]),
        uid = json["id"],
        name = json["name"],
        description = json["description"],
        displayName = json["displayName"] {
    id = D2TrackedEntityTypeRepository(db).getIdByUid(json["id"]) ?? 0;
  }

  @override
  String? displayName;
}
