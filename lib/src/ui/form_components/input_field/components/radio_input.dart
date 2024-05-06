import 'package:flutter/material.dart';

import '../models/input_field_option.dart';
import '../models/select_input_field.dart';
import 'base_input.dart';

class RadioInput extends BaseStatelessInput<D2SelectInputFieldConfig, String> {
  const RadioInput({
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
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Wrap(
        direction: Axis.horizontal,
        children: input.options!.map((D2InputFieldOption option) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Radio(
                fillColor: MaterialStatePropertyAll(
                  "$value" == option.code
                      ? decoration.colorScheme.active
                      : decoration.colorScheme.disabled,
                ),
                value: option.code,
                groupValue: value,
                onChanged: disabled ? null : onChange,
                activeColor: disabled
                    ? decoration.colorScheme.disabled
                    : decoration.colorScheme.active,
              ),
              Text(
                option.name,
                style: TextStyle(
                    color: disabled
                        ? decoration.colorScheme.disabled
                        : decoration.colorScheme.text),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
