import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:flutter/material.dart';
import 'base_input.dart';

class BooleanInput extends BaseInput<D2BooleanInputFieldConfig, String> {
  const BooleanInput({
    super.key,
    super.value,
    required super.input,
    required super.color,
    required super.onChange,
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
                  fillColor: MaterialStatePropertyAll(
                    "$value" == option.code ? color : const Color(0xFF94A0B1),
                  ),
                  activeColor: color,
                  value: option.code,
                  groupValue: value,
                  onChanged: (selectedValue) => onChange("$selectedValue"),
                ),
                Text(
                  option.name,
                  style: const TextStyle().copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
                    color: const Color(0xFF1D2B36),
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}
