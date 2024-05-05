import 'package:flutter/material.dart';

import 'base_input_field.dart';

class D2TrueOnlyInputFieldColorScheme {
  Color activeTrackColor;
  Color inactiveTrackColor;
  Color activeTrackOutlineColor;
  Color inactiveTrackOutlineColor;
  Color activeThumbColor;
  Color inactiveThumbColor;
  Color activeThumbIconColor;
  Color inactiveThumbIconColor;

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

class D2TrueOnlyInputFieldConfig extends D2BaseInputFieldConfig {
  D2TrueOnlyInputFieldColorScheme? colorScheme;

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
