import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/models/base_input_field.dart';
import 'package:flutter/material.dart';

import '../../form_section/models/form_section.dart';

class D2Form {
  String? title;
  String? subtitle;
  List<D2BaseInputFieldConfig>? fields;
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
