/// Copyright (c) 2024, HISP Tanzania Developers.
/// All rights reserved. Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.

library;

import 'package:dhis2_flutter_toolkit/src/utils/period_engine/constants/fixed_period_types.dart';
import 'package:dhis2_flutter_toolkit/src/utils/period_engine/constants/period_categories.dart';
import 'package:dhis2_flutter_toolkit/src/utils/period_engine/constants/relative_period_types.dart';
import 'package:dhis2_flutter_ui/dhis2_flutter_ui.dart';
import 'package:flutter/material.dart';

class SelectorInput extends StatelessWidget {
  final String? selected;
  final Function onChange;
  final List<Map> rawOptions;
  final Color inputColor;

  const SelectorInput(this.selected, this.onChange,
      {Key? key, required this.rawOptions, required this.inputColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<InputFieldOption> options = rawOptions
        .map((type) => InputFieldOption(code: type['id'], name: type['name']))
        .toList();
    bool isReadOnly = options.length == 1;
    return InputFieldContainer(
        inputField: InputField(
          inputColor: isReadOnly ? Theme.of(context).disabledColor : inputColor,
          labelColor: isReadOnly ? Theme.of(context).disabledColor : inputColor,
          id: 'selector',
          name: 'Period type',
          valueType: 'TEXT',
          isReadOnly: isReadOnly,
          options: options,
          renderAsRadio: false,
        ),
        hiddenInputFieldOptions: const {},
        dataObject: {'selector': selected},
        onInputValueChange: (String key, value) => onChange(value),
        hiddenFields: const {});
  }
}

class YearInput extends StatelessWidget {
  final int value;
  final Function onChange;
  final int currentYear = DateTime.now().year;
  final Color inputColor;

  YearInput(this.value, this.onChange, this.inputColor, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<InputFieldOption> options = List<InputFieldOption>.generate(
        11,
        (index) => InputFieldOption(
            code: (currentYear - index).toString(),
            name: (currentYear - index).toString()));
    return InputFieldContainer(
        inputField: InputField(
            inputColor: inputColor,
            labelColor: inputColor,
            id: 'year',
            name: "Year",
            valueType: "NUMBER",
            renderAsRadio: false,
            options: options),
        hiddenInputFieldOptions: const {},
        dataObject: {"year": value.toString()},
        onInputValueChange: (String key, value) =>
            onChange(int.tryParse(value)),
        hiddenFields: const {});
  }
}

class D2PeriodTypeSelector extends StatelessWidget {
  final String? selectedType;
  final String category;
  final Function onChange;
  final int year;
  final Color inputColor;
  final Function onYearChange;
  final List<String>? allowedPeriodTypes;
  final List<String>? excludedPeriodTypes;

  const D2PeriodTypeSelector(
    this.category,
    this.selectedType, {
    Key? key,
    required this.onChange,
    required this.year,
    required this.onYearChange,
    required this.inputColor,
    this.allowedPeriodTypes,
    this.excludedPeriodTypes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (category) {
      case D2PeriodTypeCategory.relative:
        List<Map> periodTypeOptions = d2RelativePeriodTypes;
        if (excludedPeriodTypes != null) {
          periodTypeOptions = periodTypeOptions
              .where((element) => !excludedPeriodTypes!.contains(element['id']))
              .toList();
        }
        if (allowedPeriodTypes != null) {
          periodTypeOptions = periodTypeOptions
              .where((element) => allowedPeriodTypes!.contains(element['id']))
              .toList();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SelectorInput(selectedType, onChange,
              inputColor: inputColor, rawOptions: periodTypeOptions),
        );
      case D2PeriodTypeCategory.fixed:
        List<Map> periodTypeOptions = d2FixedD2PeriodTypes;
        if (allowedPeriodTypes != null) {
          periodTypeOptions = periodTypeOptions
              .where((element) => allowedPeriodTypes!.contains(element['id']))
              .toList();
        }
        if (excludedPeriodTypes != null) {
          periodTypeOptions = periodTypeOptions
              .where((element) => !excludedPeriodTypes!.contains(element['id']))
              .toList();
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SelectorInput(selectedType, onChange,
                    inputColor: inputColor, rawOptions: periodTypeOptions),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: YearInput(year, onYearChange, inputColor),
              ),
            )
          ],
        );
    }
    return Container();
  }
}
