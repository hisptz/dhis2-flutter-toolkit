import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/input_field_icon.dart';
import 'package:flutter/material.dart';

import '../models/input_field.dart';

abstract class BaseInput extends StatelessWidget {
  final InputField input;

  final Color color;

  Widget? prefixWidget;

  final TextEditingController controller;

  final BoxConstraints prefixIconConstraints = const BoxConstraints(
      maxHeight: 45, minHeight: 42, maxWidth: 45, minWidth: 42);

  BaseInput(
      {super.key,
      required this.input,
      required this.controller,
      required this.color}) {
    if (input.svgIconAsset != null || input.icon != null) {
      prefixWidget = InputFieldIcon(
        backgroundColor: color,
        iconColor: color,
        iconData: input.icon,
        svgIcon: input.svgIconAsset,
      );
    }
  }
}
