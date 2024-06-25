import 'package:flutter/material.dart';

import 'input_field_legend.dart';
import 'input_field_type_enum.dart';

/// Configuration class for a base input field.
class D2BaseInputFieldConfig {
  /// The name of the input field.
  final String name;

  /// The label of the input field.
  final String label;

  /// The type of the input field.
  final D2InputFieldType type;

  /// Whether the input field is mandatory.
  final bool mandatory;

  /// Whether the input field is clearable.
  bool clearable;

  /// The icon of the input field.
  final IconData? icon;

  /// The SVG icon asset of the input field.
  final String? svgIconAsset;

  /// The legends associated with the input field.
  final List<D2InputFieldLegend>? legends;

  /// Creates a new instance of [D2BaseInputFieldConfig].
  ///
  /// Parameters:
  /// - [label] The label for the input field.
  /// - [type] The type of input field.
  /// - [name] The name of the input field.
  /// - [mandatory] Whether the input field is mandatory.
  /// - [clearable] Whether the input field can be cleared.
  /// - [icon] The icon for the input field.
  /// - [svgIconAsset] The SVG icon asset for the input field.
  /// - [legends] Additional legends for the input field.

  D2BaseInputFieldConfig(
      {required this.label,
      required this.type,
      required this.name,
      required this.mandatory,
      this.icon,
      this.svgIconAsset,
      this.legends,
      this.clearable = false});
}
