import 'package:flutter/material.dart';

import '../input_field/form_controlled_field_container.dart';
import '../input_field/models/base_input_field.dart';
import '../state/form_state.dart';
import 'models/form_section.dart';

class FormSectionContainerWithControlledInputs extends StatelessWidget {
  final D2FormSection section;
  final D2FormController controller;
  final Color? color;
  final bool disabled;

  const FormSectionContainerWithControlledInputs(
      {super.key,
      required this.section,
      required this.controller,
      this.color,
      this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: section.title != null,
          child: Text(
            section.title ?? '',
            style: TextStyle(
              color: color,
              fontSize: 24,
            ),
          ),
        ),
        Visibility(
          visible: section.subtitle != null,
          child: Text(
            section.subtitle ?? '',
            style: const TextStyle(color: Colors.blueGrey, fontSize: 16),
          ),
        ),
        ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              D2BaseInputFieldConfig input = section.fields[index];
              return D2FormControlledInputField(
                  disabled: disabled,
                  input: input,
                  controller: controller,
                  color: color);
            },
            separatorBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                ),
            itemCount: section.fields.length)
      ],
    );
  }
}
