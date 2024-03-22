import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:flutter/material.dart';
import 'base_input.dart';

class TrueOnlyInput extends BaseStatelessInput<D2TrueOnlyInputFieldConfig, String> {
  const TrueOnlyInput({
    super.key,
    super.value,
    required super.input,
    required super.color,
    required super.onChange,
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
        activeTrackColor: color,
        inactiveTrackColor: Colors.white,
        trackOutlineColor: MaterialStatePropertyAll(
          isSelected() ? color : const Color(0xFF94A0B1),
        ),
        thumbColor: MaterialStatePropertyAll(
          isSelected() ? Colors.white : const Color(0xFF94A0B1),
        ),
        thumbIcon: MaterialStateProperty.all(
          Icon(
            isSelected() ? Icons.check : Icons.close,
            color: isSelected() ? color : Colors.white,
          ),
        ),
        value: isSelected(),
        onChanged: (bool selectedValue) => onChange(
          selectedValue ? "$selectedValue" : "",
        ),
      ),
    );
  }
}
