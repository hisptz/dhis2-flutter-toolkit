import 'base_input_field.dart';
import 'input_field_option.dart';

class D2SelectInputFieldConfig extends D2BaseInputFieldConfig {
  List<D2InputFieldOption>? options;
  bool renderOptionsAsRadio;

  D2SelectInputFieldConfig(
      {required this.options,
      required super.label,
      required super.type,
      required super.name,
      required super.mandatory,
      super.clearable,
      super.icon,
      super.legends,
      super.svgIconAsset,
      this.renderOptionsAsRadio = false});
}
