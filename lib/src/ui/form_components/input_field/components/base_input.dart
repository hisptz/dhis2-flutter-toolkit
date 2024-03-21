import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/models/base_input_field.dart';
import 'package:flutter/material.dart';

typedef OnChange<T> = void Function(T);

abstract class BaseStatelessInput<FieldType extends D2BaseInputFieldConfig,
    ValueType> extends StatelessWidget {
  final FieldType input;
  final Color color;
  final ValueType? value;
  final OnChange<ValueType?> onChange;

  const BaseStatelessInput({
    super.key,
    required this.input,
    required this.onChange,
    required this.color,
    this.value,
  });
}

abstract class BaseStatefulInput<FieldType extends D2BaseInputFieldConfig,
    ValueType> extends StatefulWidget {
  final FieldType input;
  final Color color;
  final ValueType? value;
  final OnChange<ValueType?> onChange;

  const BaseStatefulInput({
    super.key,
    required this.input,
    required this.onChange,
    required this.color,
    this.value,
  });
}

abstract class BaseStatefulInputState<T extends BaseStatefulInput>
    extends State<T> {}
