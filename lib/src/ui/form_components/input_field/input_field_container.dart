import 'package:collection/collection.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/multi_select_input.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/multi_text_input.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/models/input_decoration_container.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/models/input_field_legend.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/models/multi_select_input_field.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/models/multi_text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/age_input/age_input.dart';
import 'components/base_input.dart';
import 'components/boolean_input.dart';
import 'components/coordinate_input/coordinate_input.dart';
import 'components/date_input.dart';
import 'components/date_range_input.dart';
import 'components/input_field_icon.dart';
import 'components/org_unit_input/org_unit_input.dart';
import 'components/radio_input.dart';
import 'components/select_input.dart';
import 'components/text_input.dart';
import 'components/true_only_input.dart';
import 'models/age_input_field.dart';
import 'models/base_input_field.dart';
import 'models/boolean_input_field.dart';
import 'models/coordinate_field.dart';
import 'models/date_input_field.dart';
import 'models/date_range_input_field.dart';
import 'models/input_field_type_enum.dart';
import 'models/number_input_field.dart';
import 'models/org_unit_input_field.dart';
import 'models/select_input_field.dart';
import 'models/text_input_field.dart';
import 'models/true_only_input_field.dart';

class D2InputFieldContainer extends StatelessWidget {
  final D2BaseInputFieldConfig input;
  final OnChange<dynamic> onChange;
  final dynamic value;
  final Color? color;
  final String? error;
  final String? warning;
  final bool disabled;
  D2InputDecoration? inputDecoration;

  D2InputFieldContainer(
      {super.key,
      required this.input,
      this.inputDecoration,
      this.value,
      required this.onChange,
      required this.color,
      this.error,
      this.disabled = false,
      this.warning}) {
    inputDecoration ??= D2InputDecoration.fromInput(input,
        color: color ?? Colors.blue,
        disabled: disabled,
        error: error != null,
        warning: warning != null);
  }

  Color get colorOverride {
    return inputDecoration!.colorScheme.getStatusColor(
        hasWarning: hasWarning, isDisabled: disabled, hasError: hasError);
  }

  void onClear() {
    onChange(null);
  }

  @override
  Widget build(BuildContext context) {
    BoxDecoration containerDecoration =
        inputDecoration!.inputContainerDecoration;

    Widget getInput() {
      if (input is D2MultiTextInputFieldConfig) {
        return MultiTextInput(
            input: input as D2MultiTextInputFieldConfig,
            onChange: onChange,
            color: colorOverride,
            decoration: inputDecoration!);
      }
      if (input is D2MultiSelectInputFieldConfig) {
        return MultiSelectInput(
          disabled: disabled,
          input: input as D2MultiSelectInputFieldConfig,
          color: colorOverride,
          onChange: onChange,
          value: value,
          decoration: inputDecoration!,
        );
      }
      if (input is D2SelectInputFieldConfig) {
        return (input as D2SelectInputFieldConfig).renderOptionsAsRadio
            ? RadioInput(
                disabled: disabled,
                input: input as D2SelectInputFieldConfig,
                color: colorOverride,
                onChange: onChange,
                value: value,
                decoration: inputDecoration!,
              )
            : SelectInput(
                disabled: disabled,
                input: input as D2SelectInputFieldConfig,
                color: colorOverride,
                onChange: onChange,
                value: value,
                decoration: inputDecoration!,
              );
      }
      if (input is D2DateInputFieldConfig) {
        return DateInput(
          disabled: disabled,
          value: value,
          input: input as D2DateInputFieldConfig,
          color: colorOverride,
          onChange: onChange,
          decoration: inputDecoration!,
        );
      }
      if (input is D2DateRangeInputFieldConfig) {
        return DateRangeInput(
          disabled: disabled,
          value: value,
          input: input as D2DateRangeInputFieldConfig,
          color: colorOverride,
          onChange: onChange,
          decoration: inputDecoration!,
        );
      }
      if (input is D2NumberInputFieldConfig) {
        switch (input.type) {
          case D2InputFieldType.number:
            return CustomTextInput(
                disabled: disabled,
                textInputType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                input: input,
                value: value,
                onChange: onChange,
                decoration: inputDecoration!,
                color: colorOverride);
          case D2InputFieldType.integer:
            return CustomTextInput(
                disabled: disabled,
                textInputType: const TextInputType.numberWithOptions(
                    signed: true, decimal: false),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^-?\d*$'))
                ],
                input: input,
                value: value,
                onChange: onChange,
                decoration: inputDecoration!,
                color: colorOverride);
          case D2InputFieldType.positiveInteger:
            return CustomTextInput(
                disabled: disabled,
                textInputType: const TextInputType.numberWithOptions(
                    decimal: false, signed: false),
                input: input,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$'))
                ],
                value: value,
                onChange: onChange,
                decoration: inputDecoration!,
                color: colorOverride);
          case D2InputFieldType.negativeInteger:
            return CustomTextInput(
                disabled: disabled,
                textInputType: const TextInputType.numberWithOptions(
                    decimal: false, signed: true),
                input: input,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^-\d*$'))
                ],
                value: value,
                onChange: onChange,
                decoration: inputDecoration!,
                color: colorOverride);
          case D2InputFieldType.integerZeroOrPositive:
            return CustomTextInput(
                disabled: disabled,
                textInputType: const TextInputType.numberWithOptions(
                    decimal: false, signed: true),
                input: input,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*$'))
                ],
                value: value,
                onChange: onChange,
                decoration: inputDecoration!,
                color: colorOverride);
          default:
            return CustomTextInput(
                disabled: disabled,
                textInputType: const TextInputType.numberWithOptions(
                    decimal: true, signed: true),
                input: input,
                value: value,
                onChange: onChange,
                decoration: inputDecoration!,
                color: colorOverride);
        }
      }
      if (input is D2TextInputFieldConfig) {
        switch (input.type) {
          case D2InputFieldType.text:
          case D2InputFieldType.longText:
          case D2InputFieldType.email:
          case D2InputFieldType.url:
            return CustomTextInput(
              decoration: inputDecoration!,
              disabled: disabled,
              onChange: onChange,
              value: value,
              input: input,
              color: colorOverride,
              maxLines: D2InputFieldType.longText == input.type ? null : 1,
              textInputType: [D2InputFieldType.text, D2InputFieldType.longText]
                      .contains(input.type)
                  ? TextInputType.text
                  : [D2InputFieldType.email].contains(input.type)
                      ? TextInputType.emailAddress
                      : [D2InputFieldType.url].contains(input.type)
                          ? TextInputType.url
                          : TextInputType.text,
            );
          default:
            return CustomTextInput(
              disabled: disabled,
              onChange: onChange,
              value: value,
              input: input,
              color: colorOverride,
              textInputType: TextInputType.text,
              decoration: inputDecoration!,
            );
        }
      }
      if (input is D2BooleanInputFieldConfig) {
        return BooleanInput(
          disabled: disabled,
          onChange: onChange,
          value: value,
          input: input as D2BooleanInputFieldConfig,
          color: colorOverride,
          decoration: inputDecoration!,
        );
      }
      if (input is D2TrueOnlyInputFieldConfig) {
        return TrueOnlyInput(
          disabled: disabled,
          onChange: onChange,
          value: value,
          input: input as D2TrueOnlyInputFieldConfig,
          color: colorOverride,
          decoration: inputDecoration!,
        );
      }
      if (input is D2OrgUnitInputFieldConfig) {
        return OrgUnitInput(
          disabled: disabled,
          value: value,
          input: input as D2OrgUnitInputFieldConfig,
          color: colorOverride,
          onChange: onChange,
          decoration: inputDecoration!,
        );
      }
      if (input is D2GeometryInputConfig) {
        return CoordinateInput(
          disabled: disabled,
          onChange: onChange,
          value: value,
          input: input as D2GeometryInputConfig,
          color: colorOverride,
          decoration: inputDecoration!,
        );
      }
      if (input is D2AgeInputFieldConfig) {
        return AgeInputField(
          input: input as D2AgeInputFieldConfig,
          onChange: onChange,
          color: colorOverride,
          value: value,
          disabled: disabled,
          decoration: inputDecoration!,
        );
      }

      return CustomTextInput(
        disabled: disabled,
        onChange: onChange,
        value: value,
        input: input,
        color: colorOverride,
        textInputType: TextInputType.text,
        decoration: inputDecoration!,
      );
    }

    Widget getPrefix() {
      return Visibility(
        visible: input.svgIconAsset != null || input.icon != null,
        child: Container(
          constraints: inputDecoration!.inputIconDecoration.iconConstraints,
          child: InputFieldIcon(
            backgroundColor:
                inputDecoration!.inputIconDecoration.backgroundColor,
            iconColor: inputDecoration!.inputIconDecoration.iconColor,
            iconData: inputDecoration!.inputIconDecoration.iconData,
            svgIcon: inputDecoration!.inputIconDecoration.svgIconAsset,
          ),
        ),
      );
    }

    List<Widget> getSuffix() {
      return [
        Visibility(
          visible: input.clearable && !disabled,
          child: IconButton(
            onPressed: onClear,
            icon: Icon(
              Icons.clear,
              color: inputDecoration!.colorScheme.text,
            ),
          ),
        ),
      ];
    }

    return Container(
      decoration: containerDecoration,
      constraints: const BoxConstraints(minHeight: 96),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: input.label,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: colorOverride),
                              ),
                              TextSpan(
                                text: input.mandatory ? ' *' : '',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.redAccent,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      getPrefix(),
                      Expanded(child: getInput()),
                      ...getSuffix(),
                    ],
                  ),
                  Visibility(
                      visible: hasError,
                      child: Text(
                        error ?? '',
                        style: TextStyle(
                          color: colorOverride,
                          fontSize: 12.0,
                        ),
                      )),
                  Visibility(
                      visible: hasWarning && !hasError,
                      child: Text(
                        warning ?? '',
                        style: TextStyle(
                          color: colorOverride,
                          fontSize: 12.0,
                        ),
                      ))
                ],
              ),
            ),
          ),
          Container(
            width: 16,
            constraints: const BoxConstraints(minHeight: 96),
            decoration: BoxDecoration(color: getActiveLegendColor()),
          )
        ],
      ),
    );
  }

  bool get hasError => error != null;

  bool get hasWarning => warning != null;

  bool get hasLegends => input.legends != null && input.legends!.isNotEmpty;

  Color getActiveLegendColor() {
    if (value is String) {
      if (input.legends == null || input.legends!.isEmpty) {
        return Colors.transparent;
      }
      if (value == null) {
        return Colors.transparent;
      }
      double? numberValue = double.tryParse(value);
      if (numberValue == null) {
        return Colors.transparent;
      }

      D2InputFieldLegend? selectedLegend =
          input.legends!.firstWhereOrNull((legend) {
        return legend.valueInRange(numberValue);
      });

      if (selectedLegend == null) {
        return Colors.transparent;
      }

      return selectedLegend.color;
    }
    return Colors.transparent;
  }
}
