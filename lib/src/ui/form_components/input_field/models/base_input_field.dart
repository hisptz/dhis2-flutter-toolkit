import 'package:flutter/material.dart';

import 'input_field_legend.dart';
import 'input_field_type_enum.dart';

class D2BaseInputFieldConfig {
  String name;
  String label;
  D2InputFieldType type;
  bool mandatory;
  bool clearable;
  IconData? icon;
  String? svgIconAsset;
  List<InputFieldLegend>? legends;

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
