import 'package:dhis2_flutter_toolkit/src/ui/form_components/utils/tracker_event_form_util.dart';
import 'package:flutter/material.dart';

import '../../../models/metadata/entry.dart';
import '../form_section/models/form_section.dart';
import '../state/form_state.dart';
import 'controlled_form.dart';
import 'models/dhis2_form_options.dart';
import 'models/form.dart';

class D2TrackerEventForm extends StatelessWidget {
  final D2FormController controller;
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
    List<D2FormSection> formSections =
        D2TrackerEventFormUtil(programStage: programStage, options: options)
            .formSections;

    Color formColor = color ?? Theme.of(context).primaryColor;

    return D2ControlledForm(
        color: formColor,
        disabled: disabled,
        form: D2Form(
            title: options.showTitle
                ? programStage.displayName ?? programStage.name
                : null,
            sections: [...options.formSections, ...formSections]),
        controller: controller);
  }
}
