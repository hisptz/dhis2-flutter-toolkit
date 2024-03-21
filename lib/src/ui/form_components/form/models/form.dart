import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/models/base_input_field.dart';
import 'package:flutter/material.dart';

import '../../form_section/models/form_section.dart';

class D2Form {
  String? title;
  String? subtitle;
  List<D2BaseInputFieldConfig>? fields;
  List<D2FormSection>? sections;
  D2Form(
      {this.title,
      this.subtitle,
      this.fields,
      this.sections,
      })
      : assert(fields != null || sections != null);
}
