import '../../../objectbox.dart';
import '../metadata/entry.dart';

abstract class D2BaseEditable {
  Map<String, dynamic> toFormValues();

  void save(D2ObjectBox db);

  void updateFromFormValues(Map<String, dynamic> values,
      {required D2ObjectBox db, D2Program? program, D2OrgUnit? orgUnit});
}
