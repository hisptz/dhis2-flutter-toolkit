import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:flutter/material.dart';
import '../state/field_state.dart';

/// A controlled input field widget that integrates with a dynamic form controller.
class D2FormControlledInputField extends StatelessWidget {
  /// The configuration for the input field.
  final D2BaseInputFieldConfig input;

  /// The color theme for the input field.
  final Color? color;

  /// The form controller managing the state of the form.
  final D2FormController controller;

  /// Whether the input field is disabled.
  final bool? disabled;

  /// Custom input decoration for the field.
  final D2InputDecoration? inputDecoration;

  /// Constructs a [D2FormControlledInputField] instance.
  /// - [input] The configuration for the input field.
  /// - [color] The color theme for the input field.
  /// - [controller] The form controller managing the state of the form.
  /// - [disabled] Whether the input field is disabled.
  /// - [inputDecoration] Custom input decoration for the field.
  const D2FormControlledInputField({
    super.key,
    required this.input,
    this.disabled,
    this.inputDecoration,
    required this.controller,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, Widget? child) {
        FieldState fieldState = controller.getFieldState(input.name);

        if (input is D2SelectInputFieldConfig) {
          (input as D2SelectInputFieldConfig).optionsToHide =
              fieldState.optionsToHide;
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
      },
    );
  }
}
