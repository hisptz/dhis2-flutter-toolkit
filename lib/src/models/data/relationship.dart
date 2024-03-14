
import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/data/relationship.dart';
import 'base.dart';
import 'upload_base.dart';

Map getRelationshipConstraints(Map json) {
  if (json["trackedEntity"] != null) {
    return {
      "type": "trackedEntity",
      "id": json["trackedEntity"]["trackedEntity"]
    };
  } else if (json["enrollment"] != null) {
    return {"type": "enrollment", "id": json["enrollment"]["enrollment"]};
  } else if (json["event"] != null) {
    return {"type": "event", "id": json["event"]["event"]};
  } else {
    return {};
  }
}

@Entity()
class D2Relationship extends SyncDataSource implements SyncableData {
  @override
  int id = 0;
  @override
  DateTime createdAt;

  @override
  DateTime updatedAt;

  @override
  @Unique()
  String uid;
  String relationshipName;
  bool bidirectional;
  String relationshipType;

  late String fromType;

  late String fromId;

  late String toType;
  late String toId;

  D2Relationship(
      this.id,
      this.createdAt,
      this.updatedAt,
      this.uid,
      this.relationshipName,
      this.bidirectional,
      this.relationshipType,
      this.fromType,
      this.fromId,
      this.toType,
      this.toId,
      this.synced);

  D2Relationship.fromMap(D2ObjectBox db, Map json)
      : createdAt = DateTime.parse(json["createdAt"]),
        updatedAt = DateTime.parse(json["updatedAt"]),
        uid = json["relationship"],
        synced = true,
        relationshipName = json["relationshipName"],
        relationshipType = json["relationshipType"],
        bidirectional = json["bidirectional"] {
    id = D2RelationshipRepository(db).getIdByUid(json["relationship"]) ?? 0;

    Map from = json["from"];
    Map to = json["to"];

    Map fromData = getRelationshipConstraints(from);
    fromType = fromData["type"];
    fromId = fromData["id"];

    Map toData = getRelationshipConstraints(to);
    toType = toData["type"];
    toId = toData["id"];
  }

  @override
  bool synced;

  @override
  Future<Map<String, dynamic>> toMap({D2ObjectBox? db}) async {
    if (db == null) {
      throw "ObjectBox instance is required";
    }

    Map<String, dynamic> payload = {
      "relationshipType": relationshipType,
      "from": {
        fromType: {fromType: fromId}
      },
      "to": {
        toType: {toType: toId}
      }
    };

    return payload;
  }
}
