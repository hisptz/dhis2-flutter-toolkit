import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import '../../repositories/data/entry.dart';
import 'entry.dart';

@Entity()

/// Represents an import summary error in the D2 system.
class D2ImportSummaryError {
  /// The unique identifier of the error.
  int id = 0;

  /// The error message.
  String message;

  /// The error code associated with the error.
  String errorCode;

  /// The unique identifier of the related entity.
  String uid;

  /// The type of the related entity (EVENT, TRACKED_ENTITY, RELATIONSHIP, ENROLLMENT).
  String type;

  /// The timestamp when the error occurred.
  DateTime timestamp;

  /// The tracked entity associated with the error.
  final trackedEntity = ToOne<D2TrackedEntity>();

  /// The event associated with the error.
  final event = ToOne<D2Event>();

  /// The relationship associated with the error.
  final relationship = ToOne<D2Relationship>();

  /// The enrollment associated with the error.
  final enrollment = ToOne<D2Enrollment>();

  /// Constructs a [D2ImportSummaryError] with the given parameters.
  ///
  /// - [message]: The error message.
  /// - [uid]: The unique identifier of the related entity.
  /// - [errorCode]: The error code.
  /// - [type]: The type of the related entity (EVENT, TRACKED_ENTITY, RELATIONSHIP, ENROLLMENT).
  /// - [timestamp]: The timestamp when the error occurred.
  D2ImportSummaryError(
      this.message, this.uid, this.errorCode, this.type, this.timestamp);

  /// Constructs a [D2ImportSummaryError] from a map.
  ///
  /// - [db]: The [D2ObjectBox] instance.
  /// - [json]: A map representing the error data.
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
