import 'package:flutter/material.dart';

import '../../../models/metadata/entry.dart';
import '../entry.dart';

///This is a Widget for displaying a controlled form for tracker events.
class D2TrackerEventForm extends StatelessWidget {
  /// Controller managing the state and behavior of the form.
  final D2TrackerEventFormController controller;

  /// Program stage associated with the form.
  final D2ProgramStage programStage;

  /// Options for configuring the form appearance and behavior.
  final D2TrackerFormOptions options;

  /// Optional color to customize the form's visual appearance.
  final Color? color;

  /// Whether the form is disabled or not.
  final bool disabled;

  /// Constructs a new [D2TrackerEventForm].
  ///
  /// - [controller] Controller managing the state and behavior of the form.
  /// - [programStage] Program stage associated with the form.
  /// - [options] Options for configuring the form appearance and behavior.
  /// - [color] Optional color to customize the form's visual appearance.
  /// - [disabled] Whether the form is disabled or not.
  const D2TrackerEventForm(
      {super.key,
      required this.controller,
      required this.programStage,
      required this.options,
      this.color,
      this.disabled = false});

  @override
  Widget build(BuildContext context) {
    List<D2FormSection> formSections = [
      ...D2TrackerEventFormUtil(
              programStage: programStage, options: options, db: controller.db)
          .formSections,
      ...options.formSections
    ];

    Color formColor = color ?? Theme.of(context).primaryColor;

    return D2ControlledForm(
        color: formColor,
        disabled: disabled,
        form: D2Form(
            title: options.showTitle
                ? programStage.displayName ?? programStage.name
                : null,
            sections: formSections),
        controller: controller);
  }
}
