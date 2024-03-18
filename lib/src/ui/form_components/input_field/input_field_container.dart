import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/base_input.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/select_input.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/text_input.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/models/base_input_field.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/models/date_input_field.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/models/number_input_field.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/models/select_input_field.dart';
import 'package:flutter/material.dart';

import 'components/date_input.dart';
import 'components/input_field_icon.dart';
import 'models/input_field_type_enum.dart';
import 'models/text_input_field.dart';

class InputFieldContainer extends StatelessWidget {
  final D2BaseInputFieldConfig input;
  final OnChange<String?> onChange;
  final dynamic value;
  final Color color;
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
      maxHeight: 45, minHeight: 42, maxWidth: 45, minWidth: 42);

  void onClear() {
    onChange(null);
  }

  @override
  Widget build(BuildContext context) {
    Color colorOverride = error != null ? Colors.red : color;

    BaseInput getInput() {
      if (input is D2SelectInputFieldConfig) {
        return SelectInput(
            input: input as D2SelectInputFieldConfig,
            color: colorOverride,
            onChange: onChange,
            value: value);
      }

      if (input is D2DateInputFieldConfig) {
        return DateInput(
          value: value,
          input: input as D2DateInputFieldConfig,
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
                textInputType:
                    const TextInputType.numberWithOptions(decimal: false),
                input: input,
                value: value,
                onChange: onChange,
                color: colorOverride);
          default:
            return TextInput(
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
            return TextInput(
              onChange: onChange,
              value: value,
              input: input,
              color: colorOverride,
              textInputType: TextInputType.text,
            );

          case D2InputFieldType.email:
            return TextInput(
                textInputType: TextInputType.emailAddress,
                input: input,
                color: colorOverride,
                onChange: onChange);
          case D2InputFieldType.url:
            return TextInput(
                onChange: onChange,
                color: colorOverride,
                input: input,
                textInputType: TextInputType.url,
                value: value);
          default:
            return TextInput(
              onChange: onChange,
              value: value,
              input: input,
              color: colorOverride,
              textInputType: TextInputType.text,
            );
        }
      }

      return TextInput(
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
          color: colorOverride.withOpacity(0.07),
          border: Border(
              left: BorderSide.none,
              right: BorderSide.none,
              top: BorderSide.none,
              bottom: BorderSide(width: 2, color: colorOverride)),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                input.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colorOverride,
                ),
              )
            ],
          ),
          Row(
            children: [getPrefix(), Expanded(child: getInput()), getSuffix()],
          ),
          error != null
              ? Text(
                  error!,
                  style: TextStyle(color: colorOverride, fontSize: 12),
                )
              : Container()
        ],
      ),
    );
  }
}
