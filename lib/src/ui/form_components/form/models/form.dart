import 'package:flutter/material.dart';

import '../../form_section/models/form_section.dart';
import '../../input_field/models/input_field.dart';

class D2Form {
  String? title;
  String? subtitle;
  List<InputField>? fields;
  List<FormSection>? sections;
  Color color;

  D2Form(
      {this.title,
      this.subtitle,
      this.fields,
      this.sections,
      required this.color})
      : assert(fields != null || sections != null);
}
