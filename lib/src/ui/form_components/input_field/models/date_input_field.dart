import 'base_input_field.dart';

class D2DateInputFieldConfig extends D2BaseInputFieldConfig {
  bool allowFutureDates;
  DateTime? firstDate;
  DateTime? lastDate;

  D2DateInputFieldConfig(
      {required super.label,
      required super.type,
      required super.name,
      required super.mandatory,
      this.allowFutureDates = false,
      this.firstDate,
      this.lastDate,
      super.clearable,
      super.icon,
      super.legends,
      super.svgIconAsset});
}
