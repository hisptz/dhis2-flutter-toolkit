import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/models/base_input_field.dart';
import 'package:flutter/material.dart';

import '../../form_section/models/form_section.dart';

/// This class represents a DHIS2 form configuration.
class D2Form {
  /// The title of the form.
  String? title;

  /// The subtitle of the form.
  String? subtitle;

  /// List of input field configurations [D2BaseInputFieldConfig] within the form.
  List<D2BaseInputFieldConfig>? fields;

  /// List of form sections [D2FormSection] within the form.
  List<D2FormSection>? sections;

  /// Constructor for creating an instance of [D2Form].
  /// - [title]: The title of the form.
  /// - [subtitle]: The subtitle of the form.
  /// - [fields]: List of input field configurations [D2BaseInputFieldConfig] within the form.
  /// - [sections]: List of form sections [D2FormSection] within the form.
  D2Form({
    this.title,
    this.subtitle,
    this.fields,
    this.sections,
  }) : assert(fields != null || sections != null);
}
