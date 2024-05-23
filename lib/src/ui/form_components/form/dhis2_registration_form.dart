import 'package:flutter/material.dart';

import '../../../models/metadata/entry.dart';
import '../entry.dart';

class D2TrackerRegistrationForm extends StatelessWidget {
  final D2TrackerEnrollmentFormController controller;
  final D2Program program;
  final D2TrackerFormOptions options;
  final Color? color;
  final bool disabled;

  const D2TrackerRegistrationForm(
      {super.key,
      required this.controller,
      required this.program,
      required this.options,
      this.color,
      this.disabled = false});

  @override
  Widget build(BuildContext context) {
    List<D2FormSection> formSections = D2TrackerEnrollmentFormUtil(
            program: program, options: options, db: controller.db)
        .formSections;
    Color formColor = color ?? Theme.of(context).primaryColor;

    return D2ControlledForm(
        disabled: disabled,
        color: formColor,
        form: D2Form(
            title: options.showTitle
                ? program.displayName ?? program.shortName
                : null,
            sections: [...options.formSections, ...formSections]),
        controller: controller);
  }
}
