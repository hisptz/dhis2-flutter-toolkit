import 'base_input_field.dart';

/// Configuration class for a boolean input field.
class D2BooleanInputFieldConfig extends D2BaseInputFieldConfig {
  /// Creates a new instance of [D2BooleanInputFieldConfig].
  ///
  /// - [label] The label for the input field.
  /// - [type] The type of input field.
  /// - [name] The name of the input field.
  /// - [mandatory] Whether the input field is mandatory.
  /// - [clearable] Whether the input field can be cleared.
  /// - [icon] The icon for the input field.
  /// - [legends] The legends for the input field.
  /// - [svgIconAsset] The SVG icon asset for the input field.
  D2BooleanInputFieldConfig(
      {required super.label,
      required super.type,
      required super.name,
      required super.mandatory,
      super.clearable,
      super.icon,
      super.legends,
      super.svgIconAsset});
}
