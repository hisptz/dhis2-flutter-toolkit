import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/models/input_decoration_container.dart';
import 'package:flutter/material.dart';

import '../state/field_state.dart';
import '../state/form_state.dart';
import 'input_field_container.dart';
import 'models/base_input_field.dart';

class D2FormControlledInputField extends StatelessWidget {
  final D2BaseInputFieldConfig input;
  final Color? color;
  final D2FormController controller;
  final bool? disabled;
  final D2InputDecoration? inputDecoration;

  const D2FormControlledInputField(
      {super.key,
      required this.input,
      this.disabled,
      this.inputDecoration,
      required this.controller,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: controller,
        builder: (BuildContext context, Widget? child) {
          FieldState fieldState = controller.getFieldState(input.name);
          return Visibility(
            visible: !(fieldState.hidden ?? false),
            child: D2InputFieldContainer(
              inputDecoration: inputDecoration,
              input: input,
              onChange: fieldState.onChange,
              color: color,
              error: fieldState.error,
              warning: fieldState.warning,
              value: fieldState.value,
              disabled: (fieldState.disabled ?? false) || (disabled ?? false),
            ),
          );
        });
  }
}
