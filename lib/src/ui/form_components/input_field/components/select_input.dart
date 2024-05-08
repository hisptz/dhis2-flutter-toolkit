import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../models/input_field_option.dart';
import '../models/select_input_field.dart';
import 'base_input.dart';

class SelectInput extends BaseStatelessInput<D2SelectInputFieldConfig, String> {
  const SelectInput({
    super.key,
    super.value,
    super.disabled,
    required super.input,
    required super.color,
    required super.onChange,
    required super.decoration,
  });

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<D2InputFieldOption>> options =
        input.options?.map((D2InputFieldOption option) {
              bool isSelected = option.code == value;
              return DropdownMenuItem<D2InputFieldOption>(
                value: option,
                child: Text(
                  option.name,
                  style: TextStyle(color: isSelected ? color : null),
                ),
              );
            }).toList() ??
            <DropdownMenuItem<D2InputFieldOption>>[];

    D2InputFieldOption? valueOption = input.options!
        .firstWhereOrNull((D2InputFieldOption option) => option.code == value);
    return DropdownButton<D2InputFieldOption>(
      alignment: Alignment.centerLeft,
      underline: Container(
        height: 0,
        color: Colors.transparent,
      ),
      iconEnabledColor: color,
      selectedItemBuilder: (context) => input.options!
          .map((e) => Align(
                alignment: Alignment.centerLeft,
                child: Text(e.name),
              ))
          .toList(),
      value: valueOption,
      focusColor: decoration.colorScheme.active.withOpacity(0.1),
      items: options,
      iconDisabledColor: Colors.grey,
      icon: Transform.rotate(
        angle: -(pi / 2),
        child: const Icon(
          Icons.chevron_left,
          size: 32,
        ),
      ),
      isExpanded: true,
      onChanged: disabled
          ? null
          : (D2InputFieldOption? selectedOption) {
              onChange(selectedOption?.code);
            },
    );
  }
}
