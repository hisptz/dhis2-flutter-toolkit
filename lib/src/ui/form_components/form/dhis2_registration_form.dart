import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:flutter/material.dart';

import '../utils/tracker_enrollment_form_util.dart';

class D2TrackerRegistrationForm extends StatelessWidget {
  final D2FormController controller;
  final D2Program program;
  final D2TrackerRegistrationFormOptions options;

  const D2TrackerRegistrationForm(
      {super.key,
      required this.controller,
      required this.program,
      required this.options});

  @override
  Widget build(BuildContext context) {
    List<FormSection> formSections =
        TrackerEnrollmentFormUtil(program: program).formSections;

    return D2ControlledForm(
        form: D2Form(
            color: options.color,
            title: options.showTitle
                ? program.displayName ?? program.shortName
                : null,
            sections: [...options.formSections, ...formSections]),
        controller: controller);
  }
}
