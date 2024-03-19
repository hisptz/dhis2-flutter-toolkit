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
    return Container(
      margin: const EdgeInsets.symmetric(),
      child: Text(input.label),
    );
  }
}
