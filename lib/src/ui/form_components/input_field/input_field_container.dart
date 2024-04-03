import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/age_input/age_input.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/base_input.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/boolean_input.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/coordinate_input/coordinate_input.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/date_range_input.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/org_unit_input/org_unit_input.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/select_input.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/text_input.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/true_only_input.dart';
import 'package:flutter/material.dart';

import 'components/date_input.dart';
import 'components/input_field_icon.dart';
import 'components/radio_input.dart';

class InputFieldContainer extends StatelessWidget {
  final D2BaseInputFieldConfig input;
  final OnChange<dynamic> onChange;
  final dynamic value;
  final Color? color;
  final String? error;
  final String? warning;
  final bool disabled;

  const InputFieldContainer(
      {super.key,
      required this.input,
      this.value,
      required this.onChange,
      required this.color,
      this.error,
      this.disabled = false,
      this.warning});

  final BoxConstraints iconConstraints = const BoxConstraints(
    maxHeight: 45.0,
    minHeight: 42.0,
    maxWidth: 45.0,
    minWidth: 42.0,
  );

  void onClear() {
    onChange(null);
  }

  @override
  Widget build(BuildContext context) {
    Color? colorOverride = (error != null && error!.isNotEmpty)
        ? Colors.red
        : disabled
            ? Colors.grey
            : color ?? Theme.of(context).primaryColor;

    Widget getInput() {
      if (input is D2SelectInputFieldConfig) {
        return (input as D2SelectInputFieldConfig).renderOptionsAsRadio
            ? RadioInput(
                disabled: disabled,
                input: input as D2SelectInputFieldConfig,
                color: colorOverride,
                onChange: onChange,
                value: value,
              )
            : SelectInput(
                disabled: disabled,
                input: input as D2SelectInputFieldConfig,
                color: colorOverride,
                onChange: onChange,
                value: value,
              );
      }
      if (input is D2DateInputFieldConfig) {
        return DateInput(
          disabled: disabled,
          value: value,
          input: input as D2DateInputFieldConfig,
          color: colorOverride,
          onChange: onChange,
        );
      }
      if (input is D2DateRangeInputFieldConfig) {
        return DateRangeInput(
          disabled: disabled,
          value: value,
          input: input as D2DateRangeInputFieldConfig,
          color: colorOverride,
          onChange: onChange,
        );
      }
      if (input is D2NumberInputFieldConfig) {
        switch (input.type) {
          case D2InputFieldType.number:
          case D2InputFieldType.integer:
          case D2InputFieldType.positiveInteger:
          case D2InputFieldType.negativeInteger:
          case D2InputFieldType.integerZeroOrPositive:
            return TextInput(
                disabled: disabled,
                textInputType:
                    const TextInputType.numberWithOptions(decimal: false),
                input: input,
                value: value,
                onChange: onChange,
                color: colorOverride);
          default:
            return TextInput(
                disabled: disabled,
                textInputType:
                    const TextInputType.numberWithOptions(decimal: false),
                input: input,
                value: value,
                onChange: onChange,
                color: colorOverride);
        }
      }
      if (input is D2TextInputFieldConfig) {
        switch (input.type) {
          case D2InputFieldType.text:
          case D2InputFieldType.longText:
          case D2InputFieldType.email:
          case D2InputFieldType.url:
            return TextInput(
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
            return TextInput(
              disabled: disabled,
              onChange: onChange,
              value: value,
              input: input,
              color: colorOverride,
              textInputType: TextInputType.text,
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
        );
      }
      if (input is D2TrueOnlyInputFieldConfig) {
        return TrueOnlyInput(
          disabled: disabled,
          onChange: onChange,
          value: value,
          input: input as D2TrueOnlyInputFieldConfig,
          color: colorOverride,
        );
      }
      if (input is D2OrgUnitInputFieldConfig) {
        return OrgUnitInput(
            disabled: disabled,
            value: value,
            input: input as D2OrgUnitInputFieldConfig,
            color: colorOverride,
            onChange: onChange);
      }
      if (input is D2GeometryInputConfig) {
        return CoordinateInput(
          disabled: disabled,
          onChange: onChange,
          value: value,
          input: input as D2GeometryInputConfig,
          color: colorOverride,
        );
      }
      if (input is D2AgeInputFieldConfig) {
        return AgeInputField(
          input: input as D2AgeInputFieldConfig,
          onChange: onChange,
          color: colorOverride,
          value: value,
          disabled: disabled,
        );
      }

      return TextInput(
        disabled: disabled,
        onChange: onChange,
        value: value,
        input: input,
        color: colorOverride,
        textInputType: TextInputType.text,
      );
    }

    Widget getPrefix() {
      if (input.svgIconAsset != null || input.icon != null) {
        return Container(
          margin: const EdgeInsets.only(left: 16.0),
          constraints: iconConstraints,
          child: InputFieldIcon(
            backgroundColor: colorOverride,
            iconColor: colorOverride,
            iconData: input.icon,
            svgIcon: input.svgIconAsset,
          ),
        );
      } else {
        return Container();
      }
    }

    Widget getSuffix() {
      return Row(
        children: [
          input.clearable
              ? IconButton(
                  onPressed: onClear,
                  icon: const Icon(Icons.clear),
                )
              : Container(),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: colorOverride.withOpacity(0.07),
        border: Border(
          left: BorderSide.none,
          right: BorderSide.none,
          top: BorderSide.none,
          bottom: BorderSide(
            width: 2,
            color: colorOverride,
          ),
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4.0),
          topRight: Radius.circular(4.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: input.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: colorOverride,
                      ),
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
            ],
          ),
          Row(
            children: [
              getPrefix(),
              Expanded(child: getInput()),
              getSuffix(),
            ],
          ),
          error != null
              ? Text(
                  error!,
                  style: TextStyle(
                    color: colorOverride,
                    fontSize: 12.0,
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
