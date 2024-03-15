import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/base_input.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/select_input.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/text_input.dart';
import 'package:flutter/material.dart';

import 'components/input_field_icon.dart';
import 'models/input_field.dart';

class InputFieldContainer extends StatelessWidget {
  final InputField input;
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
      if (input.options != null) {
        return SelectInput(
            input: input,
            color: colorOverride,
            onChange: onChange,
            value: value);
      }
      switch (input.type) {
        case InputFieldType.text:
          return TextInput(
            onChange: onChange,
            value: value,
            input: input,
            color: colorOverride,
            textInputType: TextInputType.text,
          );
        case InputFieldType.number:
        case InputFieldType.integer:
        case InputFieldType.positiveInteger:
        case InputFieldType.negativeInteger:
          return TextInput(
              textInputType:
                  const TextInputType.numberWithOptions(decimal: false),
              input: input,
              value: value,
              onChange: onChange,
              color: colorOverride);

        case InputFieldType.email:
          return TextInput(
              textInputType: TextInputType.emailAddress,
              input: input,
              color: colorOverride,
              onChange: onChange);
        case InputFieldType.url:
          return TextInput(
              onChange: onChange,
              color: colorOverride,
              input: input,
              textInputType: TextInputType.url,
              value: value);
        case InputFieldType.date:
        case InputFieldType.dateAndTime:
          return TextInput(
              textInputType: TextInputType.datetime,
              input: input,
              color: colorOverride,
              onChange: onChange);
        default:
          throw "${input.type} is currently not supported";
      }
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

    Widget getSuffixIcon() {
      switch (input.type) {
        case InputFieldType.dateAndTime:
          return Container(
            constraints: iconConstraints,
            child: InputFieldIcon(
                backgroundColor: colorOverride,
                iconColor: colorOverride,
                iconData: Icons.calendar_today),
          );
        case InputFieldType.date:
          return Container(
            constraints: iconConstraints,
            child: InputFieldIcon(
                backgroundColor: colorOverride,
                iconColor: colorOverride,
                iconData: Icons.calendar_today),
          );
        case InputFieldType.dateRange:
          return Container(
            constraints: iconConstraints,
            child: InputFieldIcon(
                backgroundColor: colorOverride,
                iconColor: colorOverride,
                iconData: Icons.date_range),
          );
        default:
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
          getSuffixIcon()
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
