import 'base_input_field.dart';

/// Configuration for a date input field in the DHIS2 system, extending [D2BaseInputFieldConfig].
class D2DateInputFieldConfig extends D2BaseInputFieldConfig {
  /// Whether future dates are allowed for input.
  bool allowFutureDates;

  /// Constructs a [D2DateInputFieldConfig] instance.
  ///
  /// - [label] The label of the input field.
  /// - [type] The type of the input field.
  /// - [name] The name of the input field.
  /// - [mandatory] Indicates if the field is mandatory.
  /// - [allowFutureDates] Whether future dates are allowed (default is false).
  D2DateInputFieldConfig({
    required super.label,
    required super.type,
    required super.name,
    required super.mandatory,
    this.allowFutureDates = false,
    super.clearable,
    super.icon,
    super.legends,
    super.svgIconAsset,
  });
}
