import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/date_time_input_field.dart';
import 'base_input.dart';
import 'input_field_icon.dart';

class DateTimeInput
    extends BaseStatelessInput<D2DateTimeInputFieldConfig, String> {
  DateTimeInput({
    super.key,
    super.disabled,
    required super.input,
    required super.onChange,
    required super.color,
    super.value,
    required super.decoration,
  });

  void onOpenDateTimeSelection(BuildContext context) async {
    // First select date
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: value != null
          ? DateTime.tryParse(value!) ?? DateTime.now()
          : DateTime.now(),
      firstDate: input.firstDate ?? DateTime(1900),
      lastDate: input.lastDate ??
          (input.allowFutureDates
              ? DateTime.now().add(Duration(days: 3650))
              : DateTime.now()),
    );

    if (selectedDate == null) {
      return;
    }

    // Then select time
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: value != null
          ? TimeOfDay.fromDateTime(DateTime.tryParse(value!) ?? DateTime.now())
          : TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              dayPeriodTextColor: Theme.of(context).colorScheme.primary,
              hourMinuteTextColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime == null) {
      return;
    }

    // Combine date and time
    final selectedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    onChange(selectedDateTime.toIso8601String());
  }

  late final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    controller = TextEditingController(
      text: value != null
          ? DateFormat('dd/MM/yyyy HH:mm').format(DateTime.tryParse(value!)!)
          : null,
    );

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
                  onOpenDateTimeSelection(context);
                },
          icon: InputFieldIcon(
            backgroundColor: color,
            iconColor: color,
            iconData: Icons.timer,
          ),
        ),
      ),
      onTap: disabled
          ? null
          : () {
              onOpenDateTimeSelection(context);
            },
    );
  }
}
