import 'package:flutter/material.dart';

import '../../../models/metadata/entry.dart';
import '../entry.dart';

/// This is a Widget for displaying a registration form for a tracker program enrollment.
class D2TrackerRegistrationForm extends StatelessWidget {
  /// The controller that manages the form data and logic.
  final D2TrackerEnrollmentFormController controller;

  /// The program for which the registration form is being displayed.
  final D2Program program;

  /// Options to configure the behavior and appearance of the form.
  final D2TrackerFormOptions options;

  /// Optional color to customize the appearance of the form.
  final Color? color;

  /// Whether the form should be disabled.
  final bool disabled;

  /// Constructs a new instance of [D2TrackerRegistrationForm].
  ///
  /// - [controller] The controller managing the form data and logic. Must not be null.
  /// - [program] The program for which the registration form is being displayed. Must not be null.
  /// - [options] Options to configure the behavior and appearance of the form. Default is an empty options object.
  /// - [color] Optional color to customize the appearance of the form.
  /// - [disabled] Whether the form should be disabled. Default is false.
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
