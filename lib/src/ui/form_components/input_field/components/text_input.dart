import 'package:flutter/material.dart';

import '../models/input_field.dart';
import 'base_input.dart';

class TextFieldInputType {
  InputFieldType type;
  TextInputType inputType;

  TextFieldInputType({required this.type, required this.inputType});
}

class TextInput extends BaseInput {
  TextInputType textInputType;

  TextInput(
      {super.key,
      required this.textInputType,
      required super.input,
      required super.controller,
      required super.color});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF1A3518),
      ),
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: prefixWidget,
          prefixIconConstraints: prefixIconConstraints),
    );
  }
}
