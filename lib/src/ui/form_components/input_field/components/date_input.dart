import 'package:dart_date/dart_date.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/models/date_input_field.dart';
import 'package:flutter/material.dart';

import 'base_input.dart';

class DateInput extends BaseInput<D2DateInputFieldConfig> {
  const DateInput(
      {super.key,
      required super.input,
      required super.onChange,
      required super.color});

  void onOpenDateSelection(context) async {
    DateTime? selectedDateTime = await showDatePicker(
        context: context,
        firstDate: DateTime.fromMillisecondsSinceEpoch(0),
        lastDate: input.allowFutureDates
            ? DateTime.now().addYears(10)
            : DateTime.now());

    onChange(selectedDateTime?.toIso8601String());
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () {
        onOpenDateSelection(context);
      },
      initialValue: value != null
          ? DateTime.tryParse(value!)?.format("dd/MM/yyyy")
          : null,
    );
  }
}
