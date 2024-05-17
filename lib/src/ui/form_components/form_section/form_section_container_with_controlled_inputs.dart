import 'package:flutter/material.dart';

import '../entry.dart';
import '../state/field_state.dart';

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
        if (section.title != null && section.title!.isNotEmpty)
          Text(
            section.title ?? '',
            style: TextStyle(
              color: color,
              fontSize: 24,
            ),
          ),
        if (section.subtitle != null && section.subtitle!.isNotEmpty)
          Text(
            section.subtitle ?? '',
            style: const TextStyle(
              color: Colors.blueGrey,
              fontSize: 16,
            ),
          ),
        Column(
          children: section.fields.map((D2BaseInputFieldConfig input) {
            return ListenableBuilder(
                listenable: controller,
                builder: (BuildContext context, Widget? child) {
                  FieldState fieldState = controller.getFieldState(input.name);

                  if (input is D2SelectInputFieldConfig) {
                    input.optionsToHide = controller.optionsToHide[input.name];
                  }
                  return Visibility(
                    visible: !(fieldState.hidden ?? false),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: D2InputFieldContainer(
                        input: input,
                        onChange: fieldState.onChange,
                        color: color,
                        error: fieldState.error,
                        warning: fieldState.warning,
                        value: fieldState.value,
                        disabled: (fieldState.disabled ?? false) || disabled,
                      ),
                    ),
                  );
                });
          }).toList(),
        )
      ],
    );
  }
}
