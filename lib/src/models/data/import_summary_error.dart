import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import '../../repositories/data/entry.dart';
import 'entry.dart';

@Entity()
class D2ImportSummaryError {
  int id = 0;

  String message;
  String errorCode;

  String uid;

  String type;
  DateTime timestamp;

  final trackedEntity = ToOne<D2TrackedEntity>();
  final event = ToOne<D2Event>();
  final relationship = ToOne<D2Relationship>();
  final enrollment = ToOne<D2Enrollment>();

  D2ImportSummaryError(
      this.message, this.uid, this.errorCode, this.type, this.timestamp);

  D2ImportSummaryError.fromMap(D2ObjectBox db, Map json)
      : message = json['message'],
        errorCode = json['errorCode'],
        uid = json['uid'],
        type = json['trackerType'],
        timestamp = DateTime.now() {
    switch (type) {
      case 'EVENT':
        event.target = D2EventRepository(db).getByUid(uid);
        break;
      case 'TRACKED_ENTITY':
        trackedEntity.target = D2TrackedEntityRepository(db).getByUid(uid);
        break;
      case 'RELATIONSHIP':
        relationship.target = D2RelationshipRepository(db).getByUid(uid);
        break;
      case 'ENROLLMENT':
        enrollment.target = D2EnrollmentRepository(db).getByUid(uid);
        break;
    }
  }
}
