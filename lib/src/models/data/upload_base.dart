import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/objectbox.dart';

abstract class SyncableData {
  abstract bool synced;

  Future<Map<String, dynamic>> toMap({D2ObjectBox? db});
}
