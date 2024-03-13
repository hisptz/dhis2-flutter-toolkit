import 'package:flutter/material.dart';

import '../models/input_field.dart';

abstract class BaseInput extends StatelessWidget {
  final InputField input;

  final Widget? prefixWidget;

  final TextEditingController controller;

  final BoxConstraints prefixIconConstraints = const BoxConstraints(
      maxHeight: 45, minHeight: 42, maxWidth: 45, minWidth: 42);

  const BaseInput(
      {super.key,
      required this.input,
      this.prefixWidget,
      required this.controller});
}
