import 'base_input_field.dart';
import 'input_field_option.dart';

/// This is a Configuration class for a select input field.
///
/// This class extends [D2BaseInputFieldConfig] and includes additional properties
/// specific to select input fields, such as options and rendering style.
class D2SelectInputFieldConfig extends D2BaseInputFieldConfig {
  /// List of selectable options for the input field.
  List<D2InputFieldOption>? options;

  /// List of option codes to hide from the selectable options.
  List<String>? optionsToHide;

  /// Whether to render the options as radio buttons.
  bool renderOptionsAsRadio;

  /// Returns the filtered list of options, excluding those specified in [optionsToHide].
  ///
  /// If [optionsToHide] is null or empty, returns all available options.
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

  /// Constructs a [D2SelectInputFieldConfig] instance with the specified parameters.
  ///
  /// - [options] is the list of selectable options for the input field.
  /// - [label] is the label for the input field.
  /// - [type] is the type of the input field.
  /// - [name] is the name of the input field.
  /// - [mandatory] indicates whether the input field is mandatory.
  /// - [optionsToHide] is the list of option codes to hide from the selectable options.
  /// - [clearable] indicates whether the input field is clearable.
  /// - [icon] is the icon for the input field.
  /// - [legends] is the list of legends for the input field.
  /// - [svgIconAsset] is the SVG icon asset for the input field.
  /// - [renderOptionsAsRadio] indicates whether to render the options as radio buttons.
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
