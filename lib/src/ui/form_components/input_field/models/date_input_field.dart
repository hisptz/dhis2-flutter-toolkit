import 'base_input_field.dart';

class D2DateInputFieldConfig extends D2BaseInputFieldConfig {
  bool allowFutureDates;

  D2DateInputFieldConfig(
      {required super.label,
      required super.type,
      required super.name,
      required super.mandatory,
      this.allowFutureDates = false,
      super.clearable,
      super.icon,
      super.legends,
      super.svgIconAsset});
}
