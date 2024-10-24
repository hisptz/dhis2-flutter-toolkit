import 'package:flutter/material.dart';

import '../models/boolean_input_field.dart';
import '../models/input_field_option.dart';
import 'base_input.dart';

class BooleanInput
    extends BaseStatelessInput<D2BooleanInputFieldConfig, String> {
  const BooleanInput({
    super.key,
    super.value,
    super.disabled,
    required super.input,
    required super.color,
    required super.onChange,
    required super.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: [
        D2InputFieldOption(code: 'true', name: 'Yes'),
        D2InputFieldOption(code: 'false', name: 'No'),
      ]
          .map(
            (D2InputFieldOption option) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio(
                  toggleable: !disabled,
                  overlayColor:
                      WidgetStatePropertyAll(decoration.colorScheme.text),
                  fillColor: WidgetStatePropertyAll(
                    "$value" == option.code
                        ? disabled
                            ? decoration.colorScheme.disabled
                            : decoration.colorScheme.active
                        : decoration.colorScheme.inactive,
                  ),
                  activeColor: disabled
                      ? decoration.colorScheme.disabled
                      : decoration.colorScheme.active,
                  value: option.code,
                  groupValue: value,
                  onChanged: disabled
                      ? null
                      : (selectedValue) => onChange("$selectedValue"),
                ),
                Text(
                  option.name,
                  style: const TextStyle().copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
                    color: decoration.colorScheme.text,
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}
