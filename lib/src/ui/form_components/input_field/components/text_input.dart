import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/models/base_input_field.dart';
import 'package:flutter/material.dart';

import '../models/input_field_type_enum.dart';
import 'base_input.dart';

class TextFieldInputType {
  D2InputFieldType type;
  TextInputType inputType;

  TextFieldInputType({required this.type, required this.inputType});
}

class TextInput extends BaseStatefulInput<D2BaseInputFieldConfig, String> {
  final TextInputType textInputType;
  final int? maxLines;

  const TextInput({
    super.key,
    super.value,
    super.disabled,
    required this.textInputType,
    required super.input,
    required super.color,
    required super.onChange,
    this.maxLines = 1,
    required super.decoration,
  });

  @override
  State<StatefulWidget> createState() {
    return TextInputState();
  }
}

class TextInputState extends BaseStatefulInputState<TextInput> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: widget.value);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TextInput oldWidget) {
    if (widget.value == null) {
      controller = TextEditingController();
    } else if (widget.value != controller.text) {
      controller.text = widget.value ?? '';
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: widget.decoration.colorScheme.active,
      enabled: !widget.disabled,
      onChanged: (String? value) {
        widget.onChange(value);
      },
      maxLines: widget.maxLines,
      keyboardType: widget.textInputType,
      style: TextStyle(
        fontSize: 14,
        color: widget.decoration.colorScheme.text,
        fontWeight: FontWeight.w500,
      ),
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
        border: InputBorder.none,
      ),
    );
  }
}
