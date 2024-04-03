import 'base_input_field.dart';

enum D2AgeInputFieldView { date, age }

class D2AgeInputFieldConfig extends D2BaseInputFieldConfig {
  D2AgeInputFieldView? defaultView;

  D2AgeInputFieldConfig(
      {required super.label,
      required super.type,
      required super.name,
      required super.mandatory,
      this.defaultView,
      super.clearable,
      super.icon,
      super.legends,
      super.svgIconAsset});
}
