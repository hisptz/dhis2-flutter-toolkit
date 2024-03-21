import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/models/base_input_field.dart';
import 'package:flutter/material.dart';

import '../models/input_field_type_enum.dart';
import 'base_input.dart';

class TextFieldInputType {
  D2InputFieldType type;
  TextInputType inputType;

  TextFieldInputType({required this.type, required this.inputType});
}

class TextInput extends BaseStatelessInput<D2BaseInputFieldConfig, String> {
  final TextInputType textInputType;
  final int? maxLines;

  const TextInput({
    super.key,
    super.value,
    required this.textInputType,
    required super.input,
    required super.color,
    required super.onChange,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      onChanged: (String? value) {
        onChange(value);
      },
      maxLines: maxLines,
      keyboardType: textInputType,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
        border: InputBorder.none,
      ),
    );
  }
}
