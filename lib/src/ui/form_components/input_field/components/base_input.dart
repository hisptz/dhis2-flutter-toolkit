import 'package:flutter/material.dart';

import '../models/input_field.dart';

typedef OnChange<T> = void Function(T);

abstract class BaseInput<ValueType> extends StatelessWidget {
  final InputField input;
  final Color color;
  final ValueType? value;
  final OnChange<ValueType> onChange;

  const BaseInput({
    super.key,
    required this.input,
    required this.onChange,
    required this.color,
    this.value,
  });
}
