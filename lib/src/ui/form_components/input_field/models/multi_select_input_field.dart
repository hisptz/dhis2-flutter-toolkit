import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';

/// Configuration for a multi-select input field, extending [D2SelectInputFieldConfig].
class D2MultiSelectInputFieldConfig extends D2SelectInputFieldConfig {
  /// Maximum number of selections allowed.
  int? maxSelections;

  /// Whether the options should be displayed horizontally.
  bool horizontal = false;

  /// Constructs a [D2MultiSelectInputFieldConfig].
  ///
  /// Parameters:
  /// - [options] Options available for selection.
  /// - [maxSelections] Maximum number of selections allowed.
  /// - [horizontal] Whether to display options horizontally.
  /// - [label] Label for the input field.
  /// - [type] Type of the input field.
  /// - [name] Name of the input field.
  /// - [mandatory] Whether the field is mandatory.
  D2MultiSelectInputFieldConfig(
      {required super.options,
      this.maxSelections,
      this.horizontal = false,
      required super.label,
      required super.type,
      required super.name,
      required super.mandatory});
}
