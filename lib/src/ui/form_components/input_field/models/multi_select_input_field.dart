import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';

class D2MultiSelectInputFieldConfig extends D2SelectInputFieldConfig {
  int? maxSelections;
  bool horizontal = false;

  D2MultiSelectInputFieldConfig(
      {required super.options,
      this.maxSelections,
      this.horizontal = false,
      required super.label,
      required super.type,
      required super.name,
      required super.mandatory});
}
