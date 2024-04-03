import 'package:dart_date/dart_date.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/models/date_input_field.dart';
import 'package:flutter/material.dart';

import 'base_input.dart';
import 'input_field_icon.dart';

class DateInput extends BaseStatelessInput<D2DateInputFieldConfig, String> {
  DateInput(
      {super.key,
      super.disabled,
      required super.input,
      required super.onChange,
      required super.color,
      super.value});

  void onOpenDateSelection(context) async {
    DateTime? selectedDateTime = await showDatePicker(
        initialDate: value != null ? DateTime.tryParse(value!) : null,
        context: context,
        firstDate: DateTime.fromMillisecondsSinceEpoch(0),
        lastDate: input.allowFutureDates
            ? DateTime.now().addYears(10)
            : DateTime.now());
    onChange(selectedDateTime?.toIso8601String());
  }

  late final TextEditingController controller;
  final BoxConstraints iconConstraints = const BoxConstraints(
      maxHeight: 45, minHeight: 42, maxWidth: 45, minWidth: 42);

  @override
  Widget build(BuildContext context) {
    controller = TextEditingController(
        text: value != null
            ? DateTime.tryParse(value!)?.format("dd/MM/yyyy")
            : null);
    return TextFormField(
        enabled: !disabled,
        showCursor: false,
        controller: controller,
        keyboardType: TextInputType.none,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: IconButton(
              color: color,
              padding: EdgeInsets.zero,
              constraints: iconConstraints,
              onPressed: disabled
                  ? null
                  : () {
                      onOpenDateSelection(context);
                    },
              icon: InputFieldIcon(
                  backgroundColor: color,
                  iconColor: color,
                  iconData: Icons.calendar_today),
            )),
        onTap: disabled
            ? null
            : () {
                onOpenDateSelection(context);
              });
  }
}
