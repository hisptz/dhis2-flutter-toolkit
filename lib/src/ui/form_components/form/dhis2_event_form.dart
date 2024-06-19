import 'package:flutter/material.dart';

import '../../../models/metadata/entry.dart';
import '../entry.dart';

class D2TrackerEventForm extends StatelessWidget {
  final D2TrackerEventFormController controller;
  final D2ProgramStage programStage;
  final D2TrackerFormOptions options;
  final Color? color;
  final bool disabled;

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
