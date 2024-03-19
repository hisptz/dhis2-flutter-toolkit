import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:flutter/material.dart';

import '../utils/tracker_enrollment_form_util.dart';

class D2TrackerEventForm extends StatelessWidget {
  final D2FormController controller;
  final D2Program program;
  final D2TrackerFormOptions options;
  final Color? color;

  const D2TrackerEventForm(
      {super.key,
      required this.controller,
      required this.program,
      required this.options,
      this.color});

  @override
  Widget build(BuildContext context) {
    List<FormSection> formSections =
        TrackerEnrollmentFormUtil(program: program).formSections;

    Color formColor = color ?? Theme.of(context).primaryColor;

    return D2ControlledForm(
        form: D2Form(
            color: formColor,
            title: options.showTitle
                ? program.displayName ?? program.shortName
                : null,
            sections: [...options.formSections, ...formSections]),
        controller: controller);
  }
}
