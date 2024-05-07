import 'base_input_field.dart';
import 'input_field_option.dart';

class D2SelectInputFieldConfig extends D2BaseInputFieldConfig {
  List<D2InputFieldOption>? options;
  List<String>? optionsToHide;
  bool renderOptionsAsRadio;

  List<D2InputFieldOption> get filteredOptions {
    if (optionsToHide == null) {
      return options ?? [];
    }
    if (optionsToHide!.isEmpty) {
      return options ?? [];
    }

    return options
            ?.where((option) => !optionsToHide!.contains(option.code))
            .toList() ??
        [];
  }

  D2SelectInputFieldConfig(
      {required this.options,
      required super.label,
      required super.type,
      required super.name,
      required super.mandatory,
      this.optionsToHide,
      super.clearable,
      super.icon,
      super.legends,
      super.svgIconAsset,
      this.renderOptionsAsRadio = false});
}
