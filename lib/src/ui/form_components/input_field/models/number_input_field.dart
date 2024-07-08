import 'base_input_field.dart';

/// Configuration for a number input field, extending [D2BaseInputFieldConfig].
class D2NumberInputFieldConfig extends D2BaseInputFieldConfig {
  /// Constructs a [D2NumberInputFieldConfig].
  ///
  /// - [label] Label for the input field.
  /// - [type] Type of the input field.
  /// - [name] Name of the input field.
  /// - [mandatory] Whether the field is mandatory.
  /// - [clearable] Whether the field can be cleared.
  /// - [icon] Icon associated with the input field.
  /// - [legends] Legends associated with the input field.
  /// - [svgIconAsset] Asset path for an SVG icon associated with the input field.
  D2NumberInputFieldConfig(
      {required super.label,
      required super.type,
      required super.name,
      required super.mandatory,
      super.clearable,
      super.icon,
      super.legends,
      super.svgIconAsset});
}
