import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/base_input.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/text_input.dart';
import 'package:flutter/material.dart';

import 'components/line_separator.dart';
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
      default:
        return TextInput(
          controller: _controller,
          input: input,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Padding(
          padding: const EdgeInsets.only(
            bottom: 5.0,
          ),
          child: _getInput(),
        ),
        LineSeparator(color: color),
      ],
    );
  }
}
