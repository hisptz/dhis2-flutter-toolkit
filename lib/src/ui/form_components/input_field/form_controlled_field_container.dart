import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/state/field_state.dart';
import 'package:flutter/material.dart';

class D2FormControlledInputField extends StatelessWidget {
  final D2BaseInputFieldConfig input;
  final Color? color;
  final D2FormController controller;
  final bool? disabled;

  const D2FormControlledInputField(
      {super.key,
      required this.input,
      this.disabled,
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
            child: InputFieldContainer(
              input: input,
              onChange: fieldState.onChange,
              color: color,
              error: fieldState.error,
              warning: fieldState.warning,
              value: fieldState.value,
              disabled: disabled ?? false,
            ),
          );
        });
  }
}
