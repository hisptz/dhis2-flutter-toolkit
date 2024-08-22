import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';

class D2MultiTextInputFieldConfig extends D2SelectInputFieldConfig {
  int? maxSelections;
  bool horizontal = false;

  D2MultiTextInputFieldConfig(
      {required super.options,
      this.maxSelections,
      this.horizontal = false,
      super.clearable,
      super.icon,
      super.legends,
      super.svgIconAsset,
      required super.label,
      required super.type,
      required super.name,
      required super.mandatory});
}
