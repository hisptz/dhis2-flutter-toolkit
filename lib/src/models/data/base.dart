
import 'uploadBase.dart';

abstract class D2DataResource {
  abstract int id;
  abstract DateTime createdAt;
  abstract DateTime updatedAt;

  static D2DataResource? fromMap() {
    return null;
  }
}

abstract class SyncDataSource extends D2DataResource implements SyncableData {}
