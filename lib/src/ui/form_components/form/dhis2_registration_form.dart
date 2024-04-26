import 'package:flutter/material.dart';

import '../../../models/metadata/entry.dart';
import '../form_section/models/form_section.dart';
import '../state/form_state.dart';
import '../utils/tracker_enrollment_form_util.dart';
import 'controlled_form.dart';
import 'models/dhis2_form_options.dart';
import 'models/form.dart';

class D2TrackerRegistrationForm extends StatelessWidget {
  final D2FormController controller;
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
    List<D2FormSection> formSections =
        D2TrackerEnrollmentFormUtil(program: program, options: options)
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
