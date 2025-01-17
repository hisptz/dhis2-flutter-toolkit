import 'base_input_field.dart';
import 'input_field_option.dart';

class D2SelectInputFieldConfig extends D2BaseInputFieldConfig {
  List<D2InputFieldOption>? options;
  List<String>? optionsToHide;
  List<String>? optionsToShow;
  bool renderOptionsAsRadio;

  List<D2InputFieldOption> get filteredOptions {
    if (optionsToShow != null && optionsToShow!.isNotEmpty) {
      return options
              ?.where((option) => optionsToShow!.contains(option.code))
              .toList() ??
          options ??
          [];
    }

    if (optionsToHide == null) {
      return options ?? [];
    }
    if (optionsToHide!.isEmpty) {
      return options ?? [];
    }
    return options
            ?.where((option) => !optionsToHide!.contains(option.code))
            .toList() ??
        options ??
        [];
  }

  D2SelectInputFieldConfig(
      {required this.options,
      required super.label,
      required super.type,
      required super.name,
      required super.mandatory,
      this.optionsToHide,
      this.optionsToShow,
      super.clearable,
      super.icon,
      super.legends,
      super.svgIconAsset,
      this.renderOptionsAsRadio = false});
}
