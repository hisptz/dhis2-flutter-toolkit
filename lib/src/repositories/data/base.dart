import '../../../objectbox.dart';

abstract class BaseDataRepository {
  D2ObjectBox db;

  BaseDataRepository(this.db);
}
