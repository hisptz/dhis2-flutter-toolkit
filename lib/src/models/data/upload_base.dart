import 'package:dhis2_flutter_toolkit/objectbox.dart';

abstract class SyncableData {
  abstract bool synced;

  Future<Map<String, dynamic>> toMap({ObjectBox? db});
}
