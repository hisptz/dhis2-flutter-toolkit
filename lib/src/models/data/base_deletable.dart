import '../../../objectbox.dart';

abstract class D2BaseDeletable {
  bool delete(D2ObjectBox db);

  void softDelete(db);
}
