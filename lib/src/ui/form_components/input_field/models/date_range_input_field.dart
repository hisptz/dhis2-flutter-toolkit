import 'base_input_field.dart';

class D2DateRangeInputFieldValue {
  DateTime start;
  DateTime end;

  D2DateRangeInputFieldValue({required this.start, required this.end});
}

class D2DateRangeInputFieldConfig extends D2BaseInputFieldConfig {
  bool allowFutureDates;

  D2DateRangeInputFieldConfig(
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
