import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:flutter/material.dart';

import '../state/field_state.dart';

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

          if (input is D2SelectInputFieldConfig) {
            //Filtering out the options as per the state
            if (fieldState.optionsToHide.isNotEmpty) {
              (input as D2SelectInputFieldConfig).options =
                  (input as D2SelectInputFieldConfig)
                      .options!
                      .where((element) =>
                          !fieldState.optionsToHide.contains(element.code))
                      .toList();
            }
          }

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
