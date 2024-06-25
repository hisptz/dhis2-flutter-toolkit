import 'base_input_field.dart';

class D2DateRangeInputFieldValue {
  DateTime start;
  DateTime end;

  D2DateRangeInputFieldValue({required this.start, required this.end});
}

/// Configuration for a date range input field in the DHIS2 system, extending [D2BaseInputFieldConfig].
class D2DateRangeInputFieldConfig extends D2BaseInputFieldConfig {
  /// Specifies whether future dates are allowed for input.
  bool allowFutureDates;

  /// Constructs a [D2DateRangeInputFieldConfig] instance.
  ///
  /// Parameters [label], [type], [name], and [mandatory] are inherited from [D2BaseInputFieldConfig].
  /// - [label] The label of the input field.
  /// - [type] The type of the input field.
  /// - [name] The name of the input field.
  /// - [mandatory] Indicates if the field is mandatory.
  /// - [allowFutureDates] Whether future dates are allowed (default is false).
  D2DateRangeInputFieldConfig({
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
