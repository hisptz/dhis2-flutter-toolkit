import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/base_input.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/select_input.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/text_input.dart';
import 'package:flutter/material.dart';

import 'components/input_field_icon.dart';
import 'models/input_field.dart';

class InputFieldContainer extends StatefulWidget {
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

  @override
  State<InputFieldContainer> createState() => _InputFieldContainerState();
}

class _InputFieldContainerState extends State<InputFieldContainer> {
  late Color color;
  late InputField input;
  late OnChange<String?> onChange;
  late String? value;
  late String? error;

  final BoxConstraints iconConstraints = const BoxConstraints(
      maxHeight: 45, minHeight: 42, maxWidth: 45, minWidth: 42);

  _initialize() {
    input = widget.input;
    onChange = widget.onChange;
    value = widget.value;
    error = widget.error;
    color = widget.color;

    if (error != null && error!.isNotEmpty) {
      color = Colors.red;
    }
  }

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  void onClear() {
    onChange(null);
  }

  BaseInput _getInput() {
    if (input.options != null) {
      return SelectInput(
          input: input, color: color, onChange: onChange, value: value);
    }
    switch (input.type) {
      case InputFieldType.text:
        return TextInput(
          onChange: onChange,
          value: value,
          input: input,
          color: color,
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
            color: color);

      case InputFieldType.email:
        return TextInput(
            textInputType: TextInputType.emailAddress,
            input: input,
            color: color,
            onChange: onChange);
      case InputFieldType.url:
        return TextInput(
            onChange: onChange,
            color: color,
            input: input,
            textInputType: TextInputType.url,
            value: value);
      case InputFieldType.date:
      case InputFieldType.dateAndTime:
        return TextInput(
            textInputType: TextInputType.datetime,
            input: input,
            color: color,
            onChange: onChange);
      default:
        throw "${input.type} is currently not supported";
    }
  }

  Widget _getPrefix() {
    if (input.svgIconAsset != null || input.icon != null) {
      return Container(
        constraints: iconConstraints,
        child: InputFieldIcon(
          backgroundColor: color,
          iconColor: color,
          iconData: input.icon,
          svgIcon: input.svgIconAsset,
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _getSuffixIcon() {
    switch (input.type) {
      case InputFieldType.dateAndTime:
        return Container(
          constraints: iconConstraints,
          child: InputFieldIcon(
              backgroundColor: color,
              iconColor: color,
              iconData: Icons.calendar_today),
        );
      case InputFieldType.date:
        return Container(
          constraints: iconConstraints,
          child: InputFieldIcon(
              backgroundColor: color,
              iconColor: color,
              iconData: Icons.calendar_today),
        );
      case InputFieldType.dateRange:
        return Container(
          constraints: iconConstraints,
          child: InputFieldIcon(
              backgroundColor: color,
              iconColor: color,
              iconData: Icons.date_range),
        );
      default:
        return Container();
    }
  }

  Widget _getSuffix() {
    return Row(
      children: [
        input.clearable
            ? IconButton(
                onPressed: onClear,
                icon: const Icon(Icons.clear),
              )
            : Container(),
        _getSuffixIcon()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          border: Border(
              left: BorderSide.none,
              right: BorderSide.none,
              top: BorderSide.none,
              bottom: BorderSide(width: 2, color: color)),
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
                  color: color,
                ),
              )
            ],
          ),
          Row(
            children: [
              _getPrefix(),
              Expanded(child: _getInput()),
              _getSuffix()
            ],
          ),
          error != null
              ? Text(
                  error!,
                  style: TextStyle(color: color, fontSize: 12),
                )
              : Container()
        ],
      ),
    );
  }
}
