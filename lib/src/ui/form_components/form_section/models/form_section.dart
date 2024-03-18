import 'package:flutter/material.dart';

import '../../input_field/models/base_input_field.dart';

class FormSection {
  final String id;
  final String? title;
  final String? subtitle;
  final List<D2BaseInputFieldConfig> fields;
  final Color color;

  FormSection(
      {this.title,
      this.subtitle,
      required this.id,
      required this.fields,
      required this.color});
}
