import 'package:flutter/material.dart';

import '../../../../dhis2_flutter_toolkit.dart';
import '../input_field/form_controlled_field_container.dart';
import '../input_field/models/base_input_field.dart';

class FormSectionContainerWithControlledInputs extends StatelessWidget {
  final FormSection section;
  final D2FormController controller;

  const FormSectionContainerWithControlledInputs(
      {super.key, required this.section, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        section.title != null
            ? Text(
                section.title!,
                style: TextStyle(
                  color: section.color,
                  fontSize: 24,
                ),
              )
            : Container(),
        const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
        section.subtitle != null
            ? Text(
                section.subtitle!,
                style: const TextStyle(color: Colors.blueGrey, fontSize: 16),
              )
            : Container(),
        const Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
        ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              D2BaseInputFieldConfig input = section.fields[index];
              return D2FormControlledInputField(
                  input: input, controller: controller, color: section.color);
            },
            separatorBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                ),
            itemCount: section.fields.length)
      ],
    );
  }
}
