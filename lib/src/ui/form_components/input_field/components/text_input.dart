import 'package:flutter/material.dart';

import '../models/input_field.dart';
import 'base_input.dart';

class TextFieldInputType {
  InputFieldType type;
  TextInputType inputType;

  TextFieldInputType({required this.type, required this.inputType});
}

class TextInput extends BaseInput<String> {
  TextInputType textInputType;

  TextInput(
      {super.key,
      super.value,
      required this.textInputType,
      required super.input,
      required super.color,
      required super.onChange});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      onChanged: onChange,
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
