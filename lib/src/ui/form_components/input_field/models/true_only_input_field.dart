import 'package:flutter/material.dart';

import 'base_input_field.dart';

/// This is a Color scheme class for a true-only input field.
class D2TrueOnlyInputFieldColorScheme {
  /// Color when the input field is active (true).
  Color activeTrackColor;

  /// Color when the input field is inactive (false).
  Color inactiveTrackColor;

  /// Outline color when the input field is active (true).
  Color activeTrackOutlineColor;

  /// Outline color when the input field is inactive (false).
  Color inactiveTrackOutlineColor;

  /// Color of the thumb when the input field is active (true).
  Color activeThumbColor;

  /// Color of the thumb when the input field is inactive (false).
  Color inactiveThumbColor;

  /// Color of the icon on the thumb when the input field is active (true).
  Color activeThumbIconColor;

  /// Color of the icon on the thumb when the input field is inactive (false).
  Color inactiveThumbIconColor;

  /// Constructs a new instance of [D2TrueOnlyInputFieldColorScheme].
  ///
  /// - [main] The main color used for active states.
  D2TrueOnlyInputFieldColorScheme.fromMainColor(Color main)
      : activeTrackColor = main,
        inactiveTrackColor = Colors.white,
        activeTrackOutlineColor = main,
        inactiveTrackOutlineColor = const Color(0xFF94A0B1),
        activeThumbColor = Colors.white,
        inactiveThumbColor = const Color(0xFF94A0B1),
        activeThumbIconColor = main,
        inactiveThumbIconColor = Colors.white;
}

/// This is a configuration class for a true-only input field.
class D2TrueOnlyInputFieldConfig extends D2BaseInputFieldConfig {
  /// Color scheme specific to the true-only input field.
  D2TrueOnlyInputFieldColorScheme? colorScheme;

  /// Constructs a new instance of [D2TrueOnlyInputFieldConfig].
  ///
  /// - [label] The label for the input field. Required.
  /// - [type] The type of the input field. Required.
  /// - [name] The name or key for the input field. Required.
  /// - [mandatory] Whether the input field is mandatory. Required.
  /// - [clearable] Whether the input field can be cleared. Defaults to null.
  /// - [icon] Optional icon associated with the input field. Defaults to null.
  /// - [legends] Optional legends associated with the input field. Defaults to null.
  /// - [svgIconAsset] Optional SVG icon asset associated with the input field. Defaults to null.
  D2TrueOnlyInputFieldConfig(
      {required super.label,
      required super.type,
      required super.name,
      required super.mandatory,
      this.colorScheme,
      super.clearable,
      super.icon,
      super.legends,
      super.svgIconAsset});
}
