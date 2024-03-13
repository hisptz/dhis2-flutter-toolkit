import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../models/input_field.dart';
import 'base_input.dart';

class SelectInput extends BaseInput<String> {
  SelectInput(
      {super.key,
      super.value,
      required super.input,
      required super.color,
      required super.onChange});

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<InputFieldOption>> options =
        input.options?.map((InputFieldOption option) {
              bool isSelected = option.code == value;
              return DropdownMenuItem<InputFieldOption>(
                value: option,
                child: Text(
                  option.name,
                  style: TextStyle(color: isSelected ? color : null),
                ),
              );
            }).toList() ??
            <DropdownMenuItem<InputFieldOption>>[];

    InputFieldOption? valueOption = input.options!
        .firstWhereOrNull((InputFieldOption option) => option.code == value);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        prefixWidget != null
            ? Container(
                constraints: prefixIconConstraints,
                child: prefixWidget,
              )
            : Container(),
        Expanded(
          child: DropdownButton<InputFieldOption>(
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
            focusColor: color,
            items: options,
            icon: Transform.rotate(
              angle: -(pi / 2),
              child: const Icon(
                Icons.chevron_left,
                size: 32,
              ),
            ),
            isExpanded: true,
            onChanged: (InputFieldOption? selectedOption) {},
          ),
        )
      ],
    );
  }
}
