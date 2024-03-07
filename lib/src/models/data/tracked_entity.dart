
import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/data/tracked_entity.dart';
import '../../repositories/metadata/org_unit.dart';
import '../../repositories/metadata/tracked_entity_type.dart';
import '../metadata/org_unit.dart';
import '../metadata/tracked_entity_type.dart';
import 'base.dart';
import 'enrollment.dart';
import 'event.dart';
import 'tracked_entity_attribute_value.dart';
import 'upload_base.dart';

@Entity()
class D2TrackedEntity extends SyncDataSource implements SyncableData {
  @override
  int id = 0;
  @override
  DateTime createdAt;

  @override
  DateTime updatedAt;

  @Unique()
  String uid;
  bool potentialDuplicate;
  bool deleted;
  bool inactive;

  @Backlink("trackedEntity")
  final enrollments = ToMany<D2Enrollment>();

  //Disabled for now
  // final relationships = ToMany<D2Relationship>();

  final orgUnit = ToOne<D2OrgUnit>();

  @Backlink("trackedEntity")
  final attributes = ToMany<D2TrackedEntityAttributeValue>();

  final trackedEntityType = ToOne<D2TrackedEntityType>();

  @Backlink()
  final events = ToMany<D2Event>();

  D2TrackedEntity(this.uid, this.createdAt, this.updatedAt, this.deleted,
      this.potentialDuplicate, this.inactive, this.synced);

  D2TrackedEntity.fromMap(D2ObjectBox db, Map json)
      : uid = json["trackedEntity"],
        createdAt = DateTime.parse(json["createdAt"]),
        updatedAt = DateTime.parse(json["updatedAt"]),
        deleted = json["deleted"],
        synced = true,
        potentialDuplicate = json["potentialDuplicate"],
        inactive = json["inactive"] {
    id = D2TrackedEntityRepository(db).getIdByUid(json["trackedEntity"]) ?? 0;
    orgUnit.target = D2OrgUnitRepository(db).getByUid(json["orgUnit"]);
    trackedEntityType.target =
        D2TrackedEntityTypeRepository(db).getByUid(json["trackedEntityType"]);
  }

  @override
  bool synced;

  @override
  Future<Map<String, dynamic>> toMap({D2ObjectBox? db}) async {
    if (db == null) {
      throw "ObjectBox instance is required";
    }

    List<Map<String, dynamic>> attributesPayload = await Future.wait(attributes
        .map<Future<Map<String, dynamic>>>((e) => e.toMap(db: db))
        .toList());

    Map<String, dynamic> payload = {
      "orgUnit": orgUnit.target!.uid,
      "trackedEntity": uid,
      "trackedEntityType": trackedEntityType.target!.uid,
      "attributes": attributesPayload,
    };

    return payload;
  }
}
