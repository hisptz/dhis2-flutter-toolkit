import 'base_input_field.dart';

/// The view options for the D2AgeInputField.
enum D2AgeInputFieldView { date, age }

/// Configuration for the age input field.
///
/// Extends [D2BaseInputFieldConfig].
///
/// Example usage:
/// ```dart
/// D2AgeInputFieldConfig config = D2AgeInputFieldConfig(
///   label: 'Age',
///   type: 'age',
///   name: 'age_field',
///   mandatory: true,
///   defaultView: D2AgeInputFieldView.age,
/// );
/// ```
class D2AgeInputFieldConfig extends D2BaseInputFieldConfig {
  /// The default view for the input field.
  D2AgeInputFieldView? defaultView;

  /// Creates a new instance of [D2AgeInputFieldConfig].
  ///
  /// - [label] The label for the input field.
  /// - [type] The type of input field.
  /// - [name] The name of the input field.
  /// - [mandatory] Indicates if the input field is mandatory.
  /// - [defaultView] (optional) The default view for the input field.
  /// - [clearable] (optional) Indicates if the input field can be cleared.
  /// - [icon] (optional) The icon for the input field.
  /// - [legends] (optional) Additional legends for the input field.
  /// - [svgIconAsset] (optional) The SVG icon asset for the input field.
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
