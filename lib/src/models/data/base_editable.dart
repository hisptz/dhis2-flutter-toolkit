import '../../../objectbox.dart';

abstract class D2BaseEditable {
  Map<String, dynamic> toFormValues();

  void save(D2ObjectBox db);
}
