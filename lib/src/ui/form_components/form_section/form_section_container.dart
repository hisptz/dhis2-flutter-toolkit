import 'package:flutter/material.dart';

import '../form/form_container.dart';
import '../input_field/input_field_container.dart';
import '../input_field/models/base_input_field.dart';
import 'models/form_section.dart';

class FormSectionContainer extends StatelessWidget {
  final D2FormSection section;
  final OnFormFieldChange<String?> onFieldChange;
  final Color? color;
  final bool disabled;

  const FormSectionContainer(
      {super.key,
      required this.section,
      required this.onFieldChange,
      this.disabled = false,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        section.title != null
            ? Text(
                section.title!,
                style: TextStyle(
                  color: color,
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
        Column(
          children: section.fields.map((D2BaseInputFieldConfig input) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: D2InputFieldContainer(
                disabled: disabled,
                input: input,
                onChange: (value) {
                  return onFieldChange(input.name, value);
                },
                color: color,
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}
