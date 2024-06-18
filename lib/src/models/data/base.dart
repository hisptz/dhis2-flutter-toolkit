import 'upload_base.dart';

/// This is class represents a data resource in the DHIS2 system.
abstract class D2DataResource {
  /// The ID of the data resource.
  abstract int id;

  /// The date and time when the data resource was created.
  abstract DateTime createdAt;

  /// The date and time when the data resource was last updated.
  abstract DateTime updatedAt;

  /// Creates a [D2DataResource] instance from a map.
  static D2DataResource? fromMap() {
    return null;
  }
}

/// This class represents a synchronized data source.
abstract class SyncDataSource extends D2DataResource implements SyncableData {
  /// The unique identifier (UID) of the sync data source.
  abstract String uid;
}
