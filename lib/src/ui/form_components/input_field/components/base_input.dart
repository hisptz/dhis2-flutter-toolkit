import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/input_field_icon.dart';
import 'package:flutter/material.dart';

import '../models/input_field.dart';

typedef OnChange<T> = void Function(T);

abstract class BaseInput<ValueType> extends StatelessWidget {
  final InputField input;
  final Color color;
  Widget? prefixWidget;
  ValueType? value;
  OnChange<ValueType> onChange;

  final BoxConstraints prefixIconConstraints = const BoxConstraints(
      maxHeight: 45, minHeight: 42, maxWidth: 45, minWidth: 42);

  BaseInput(
      {super.key,
      required this.input,
      required this.onChange,
      required this.color,
      this.value}) {
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
