import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/capitalize.dart';
import '../../../entry.dart';
import '../base_input.dart';
import '../date_input.dart';

enum AgeType { years, months, days }

const DAYS_IN_MONTH = 30;
const DAYS_IN_YEAR = 365;

const DATE_FORMAT = 'yyyy-MM-dd';

class AgeInputField extends BaseStatefulInput<D2AgeInputFieldConfig, String> {
  const AgeInputField(
      {super.key,
      required super.input,
      required super.onChange,
      required super.color,
      super.disabled,
      super.value,
      required super.decoration});

  @override
  State<StatefulWidget> createState() {
    return AgeInputFieldState();
  }
}

class AgeInputFieldState extends BaseStatefulInputState<AgeInputField> {
  D2AgeInputFieldView? selectedView;
  late TextEditingController _textEditingController;
  late FocusNode textFocusNode;

  AgeType? ageType;

  String? getTextValue() {
    String? value = widget.value;

    if (value == null) {
      return null;
    }
    DateTime? date = DateTime.tryParse(value);
    if (date == null) {
      return null;
    }

    int days = DateTime.now().differenceInDays(date).abs();

    switch (ageType) {
      case AgeType.days:
        return days.round().toString();
      case AgeType.months:
        return (days / DAYS_IN_MONTH).round().toString();
      case AgeType.years:
        return (days / DAYS_IN_YEAR).round().toString();
      case null:
        return '';
    }
  }

  void setTextValue(String value) {
    int? valueInt = int.tryParse(value);
    if (valueInt == null) {
      return;
    }
    switch (ageType) {
      case AgeType.years:
        DateTime dob = DateTime.now().subYears(valueInt);
        widget.onChange(dob.format(DATE_FORMAT));
        break;
      case AgeType.months:
        DateTime dob = DateTime.now().subMonths(valueInt);
        widget.onChange(dob.format(DATE_FORMAT));
        break;
      case AgeType.days:
        DateTime dob = DateTime.now().subDays(valueInt);
        widget.onChange(dob.format(DATE_FORMAT));
        break;
      case null:
        return;
    }
  }

  AgeType normalizeAgeType() {
    if (widget.value == null) {
      return AgeType.years;
    }
    int noOfDays =
        DateTime.parse(widget.value!).differenceInDays(DateTime.now()).abs();

    if (noOfDays > DAYS_IN_YEAR) {
      return AgeType.years;
    }

    if (noOfDays > DAYS_IN_MONTH) {
      //More than a month
      return AgeType.months;
    }

    return AgeType.days;
  }

  @override
  void initState() {
    textFocusNode = FocusNode();
    if (widget.value != null) {
      selectedView = D2AgeInputFieldView.age;
      ageType = normalizeAgeType();
    }
    _textEditingController = TextEditingController(text: getTextValue());
    super.initState();
  }

  @override
  void dispose() {
    textFocusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AgeInputField oldWidget) {
    if (widget.value == null) {
      setState(() {
        _textEditingController.text = "";
        selectedView = null;
      });
    }
    if (widget.value != oldWidget.value) {
      _textEditingController.text = getTextValue() ?? "";
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    D2AgeInputFieldConfig input = widget.input;

    if (selectedView == D2AgeInputFieldView.date) {
      return DateInput(
        disabled: widget.disabled,
        value: widget.value,
        input: D2DateInputFieldConfig(
            label: input.label,
            type: D2InputFieldType.date,
            allowFutureDates: false,
            mandatory: input.mandatory,
            name: input.name,
            clearable: input.clearable,
            icon: input.icon,
            legends: input.legends,
            svgIconAsset: input.svgIconAsset),
        onChange: (String? value) {
          if (value != null) {
            widget.onChange(DateTime.tryParse(value)?.format(DATE_FORMAT));
          }
        },
        color: widget.color,
        decoration: widget.decoration,
      );
    }

    if (selectedView == D2AgeInputFieldView.age) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            focusNode: textFocusNode,
            enabled: !widget.disabled,
            controller: _textEditingController,
            onChanged: (String? value) {
              if (value != null) {
                if (value.isNotEmpty) {
                  setTextValue(value);
                } else {
                  widget.onChange(null);
                }
              } else {
                widget.onChange(value);
              }
            },
            keyboardType: const TextInputType.numberWithOptions(
                signed: false, decimal: false),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
                suffixText: ageType?.name, border: InputBorder.none),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: widget.color.withOpacity(0.5),
                  width: 1,
                ),
              ),
            ),
            child: Wrap(
              alignment: WrapAlignment.start,
              children: AgeType.values
                  .map(
                    (AgeType option) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio(
                          activeColor: widget.color,
                          value: option,
                          groupValue: ageType,
                          onChanged: (value) {
                            setState(() {
                              ageType = option;
                              setTextValue(_textEditingController.text);
                              textFocusNode.requestFocus();
                            });
                          },
                        ),
                        Text(
                          capitalize(option.name),
                          style: const TextStyle().copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.0,
                            color: const Color(0xFF1D2B36),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      );
    }

    return Wrap(
      children: [
        Row(
          children: [
            TextButton(
                onPressed: () {
                  setState(() {
                    selectedView = D2AgeInputFieldView.date;
                  });
                },
                child: const Text("DATE OF BIRTH")),
            const Text("OR"),
            TextButton(
              onPressed: () {
                setState(() {
                  selectedView = D2AgeInputFieldView.age;
                  ageType = AgeType.years;
                });
              },
              child: const Text("AGE"),
            ),
          ],
        )
      ],
    );
  }
}
