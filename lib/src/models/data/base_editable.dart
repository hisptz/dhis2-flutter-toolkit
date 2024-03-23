import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';

abstract class D2BaseEditable {
  Map<String, dynamic> toFormValues();

  void updateFromFormValues(Map<String, dynamic> values,
      {required D2ObjectBox db, D2OrgUnit? orgUnit});
}
