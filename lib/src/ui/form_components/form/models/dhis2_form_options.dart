import 'package:flutter/material.dart';

import '../../form_section/models/form_section.dart';

class D2TrackerRegistrationFormOptions {
  final bool showTitle;
  final bool showRegistrationMetaInfo;
  final Color color;

  final List<FormSection> formSections;

  D2TrackerRegistrationFormOptions(
      {this.showTitle = false,
      this.showRegistrationMetaInfo = true,
      required this.color,
      this.formSections = const []});
}
