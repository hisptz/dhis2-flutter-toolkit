import 'package:flutter/material.dart';

import '../../input_field/models/input_field.dart';

class FormSection {
  final String? title;
  final String? subtitle;
  final List<InputField> fields;
  final Color color;

  FormSection(
      {this.title,
      this.subtitle,
      required this.fields,
      required this.color});
}
