import 'upload_base.dart';

abstract class D2DataResource {
  abstract int id;
  abstract DateTime createdAt;
  abstract DateTime updatedAt;

  static D2DataResource? fromMap() {
    return null;
  }
}

abstract class SyncDataSource extends D2DataResource implements SyncableData {
  abstract String uid;

  @override
  int get hashCode => uid.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SyncDataSource &&
            runtimeType == other.runtimeType &&
            uid == other.uid;
  }
}
