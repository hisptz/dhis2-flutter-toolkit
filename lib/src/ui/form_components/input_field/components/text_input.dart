import 'package:flutter/material.dart';

import 'base_input.dart';

class TextInput extends BaseInput {
  const TextInput({super.key, required super.input, required super.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
