import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/base_input.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/text_input.dart';
import 'package:flutter/material.dart';

import 'models/input_field.dart';

class InputFieldContainer extends StatelessWidget {
  final InputField input;
  final Function onChange;
  final dynamic value;
  final Color color;
  final String? error;
  final String? warning;
  final bool disabled;

  final TextEditingController _controller = TextEditingController();

  InputFieldContainer(
      {super.key,
      required this.input,
      this.value,
      required this.onChange,
      required this.color,
      this.error,
      this.disabled = false,
      this.warning});

  BaseInput _getInput() {
    switch (input.type) {
      case InputFieldType.text:
        return TextInput(
          controller: _controller,
          input: input,
          color: color,
          textInputType: TextInputType.text,
        );
      case InputFieldType.number:
      case InputFieldType.integer:
      case InputFieldType.positiveInteger:
      case InputFieldType.negativeInteger:
        return TextInput(
            textInputType:
                const TextInputType.numberWithOptions(decimal: false),
            input: input,
            controller: _controller,
            color: color);
      default:
        throw "${input.type} is currently not supported";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          border: Border(
              left: BorderSide.none,
              right: BorderSide.none,
              top: BorderSide.none,
              bottom: BorderSide(width: 2, color: color)),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0))),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                input.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              )
            ],
          ),
          _getInput(),
        ],
      ),
    );
  }
}
