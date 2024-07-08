import 'base_input_field.dart';

/// This is a configuration class for a text input field.
///
/// This class defines the properties and configuration options for a text input field
class D2TextInputFieldConfig extends D2BaseInputFieldConfig {
  /// Constructs a [D2TextInputFieldConfig] instance with the specified properties.
  ///
  /// - [label] is the label for the input field.
  /// - [type] is the type of the input field.
  /// - [name] is the name of the input field.
  /// - [mandatory] indicates whether the input field is mandatory.
  /// - [clearable] indicates whether the input field can be cleared (optional).
  /// - [icon] is the icon associated with the input field (optional).
  /// - [legends] are the legends associated with the input field (optional).
  /// - [svgIconAsset] is the SVG icon asset associated with the input field (optional).
  D2TextInputFieldConfig(
      {required super.label,
      required super.type,
      required super.name,
      required super.mandatory,
      super.clearable,
      super.icon,
      super.legends,
      super.svgIconAsset});
}
