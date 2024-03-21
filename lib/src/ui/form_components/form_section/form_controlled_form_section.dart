import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:flutter/material.dart';

import '../input_field/models/base_input_field.dart';
import '../state/section_state.dart';
import 'form_section_container_with_controlled_inputs.dart';

class D2FormControlledFormSection extends StatelessWidget {
  final D2FormSection section;
  final D2FormController controller;

  const D2FormControlledFormSection(
      {super.key, required this.section, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: controller,
        builder: (BuildContext context, Widget? child) {
          SectionState sectionState = controller.getSectionState(
              section.id,
              section.fields
                  .map((D2BaseInputFieldConfig field) => field.name)
                  .toList());
          return Visibility(
            visible: !(sectionState.hidden ?? false),
            child: FormSectionContainerWithControlledInputs(
              section: section,
              controller: controller,
            ),
          );
        });
  }
}
