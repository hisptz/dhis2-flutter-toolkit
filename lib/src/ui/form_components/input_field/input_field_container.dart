import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/base_input.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/select_input.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/components/text_input.dart';
import 'package:flutter/material.dart';

import 'components/input_field_icon.dart';
import 'models/input_field.dart';

class InputFieldContainer extends StatefulWidget {
  final InputField input;
  final OnChange<String> onChange;
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

  final BoxConstraints iconConstraints = const BoxConstraints(
      maxHeight: 45, minHeight: 42, maxWidth: 45, minWidth: 42);

  @override
  void initState() {
    super.initState();
  }

  BaseInput _getInput() {
    if (widget.input.options != null) {
      return SelectInput(
          input: widget.input,
          color: widget.color,
          onChange: widget.onChange,
          value: widget.value);
    }
    switch (widget.input.type) {
      case InputFieldType.text:
        return TextInput(
          onChange: widget.onChange,
          value: widget.value,
          input: widget.input,
          color: widget.color,
          textInputType: TextInputType.text,
        );
      case InputFieldType.number:
      case InputFieldType.integer:
      case InputFieldType.positiveInteger:
      case InputFieldType.negativeInteger:
        return TextInput(
            textInputType:
                const TextInputType.numberWithOptions(decimal: false),
            input: widget.input,
            value: widget.value,
            onChange: widget.onChange,
            color: widget.color);

      case InputFieldType.date:
      case InputFieldType.dateAndTime:
        return TextInput(
            textInputType: TextInputType.datetime,
            input: widget.input,
            color: widget.color,
            onChange: widget.onChange);
      default:
        throw "${widget.input.type} is currently not supported";
    }
  }

  Widget _getPrefix() {
    if (widget.input.svgIconAsset != null || widget.input.icon != null) {
      return Container(
        constraints: iconConstraints,
        child: InputFieldIcon(
          backgroundColor: widget.color,
          iconColor: widget.color,
          iconData: widget.input.icon,
          svgIcon: widget.input.svgIconAsset,
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _getSuffixIcon() {
    switch (widget.input.type) {
      case InputFieldType.dateAndTime:
      case InputFieldType.date:
      case InputFieldType.dateRange:
        return Container(
          constraints: iconConstraints,
          child: InputFieldIcon(
              backgroundColor: widget.color,
              iconColor: widget.color,
              iconData: Icons.calendar_month),
        );
      default:
        return Container();
    }
  }

  Widget _getSuffix() {
    return Row(
      children: [
        widget.input.clearable
            ? IconButton(
                onPressed: () {},
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
          color: widget.color.withOpacity(0.07),
          border: Border(
              left: BorderSide.none,
              right: BorderSide.none,
              top: BorderSide.none,
              bottom: BorderSide(width: 2, color: widget.color)),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0))),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                widget.input.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: widget.color,
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
        ],
      ),
    );
  }
}
