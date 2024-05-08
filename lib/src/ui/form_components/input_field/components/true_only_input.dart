import 'package:flutter/material.dart';

import '../models/true_only_input_field.dart';
import 'base_input.dart';

class TrueOnlyInput
    extends BaseStatelessInput<D2TrueOnlyInputFieldConfig, String> {
  const TrueOnlyInput({
    super.key,
    super.value,
    super.disabled,
    required super.input,
    required super.color,
    required super.onChange,
    required super.decoration,
  });

  bool isSelected() {
    return "$value" == 'true';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(),
      child: Switch(
        activeTrackColor: input.colorScheme?.activeTrackColor ?? color,
        inactiveTrackColor:
            input.colorScheme?.inactiveTrackColor ?? Colors.white,
        trackOutlineColor: MaterialStatePropertyAll(
          isSelected()
              ? input.colorScheme?.activeTrackOutlineColor ?? color
              : input.colorScheme?.inactiveTrackOutlineColor ??
                  const Color(0xFF94A0B1),
        ),
        thumbColor: MaterialStatePropertyAll(
          isSelected()
              ? input.colorScheme?.activeThumbColor ?? Colors.white
              : input.colorScheme?.inactiveThumbColor ??
                  const Color(0xFF94A0B1),
        ),
        thumbIcon: MaterialStateProperty.all(
          Icon(
            isSelected() ? Icons.check : Icons.close,
            color: isSelected()
                ? input.colorScheme?.activeThumbIconColor ?? color
                : input.colorScheme?.inactiveThumbIconColor ?? Colors.white,
          ),
        ),
        value: isSelected(),
        onChanged: disabled
            ? null
            : (bool selectedValue) => onChange(
                  selectedValue ? "$selectedValue" : "",
                ),
      ),
    );
  }
}
