import 'package:flutter/material.dart';

import '../entry.dart';

// ignore: must_be_immutable
class FormSectionContainerWithControlledInputs extends StatefulWidget {
  final D2FormSection section;
  final D2FormController controller;
  final Color? color;
  final bool disabled;
  bool collapsed;
  bool hasError;
  final bool isCollapsable;

  FormSectionContainerWithControlledInputs(
      {super.key,
      required this.section,
      required this.controller,
      this.color,
      this.isCollapsable = false,
      this.collapsed = false,
      this.hasError = false,
      this.disabled = false});

  @override
  State<FormSectionContainerWithControlledInputs> createState() =>
      _FormSectionContainerWithControlledInputsState();
}

class _FormSectionContainerWithControlledInputsState
    extends State<FormSectionContainerWithControlledInputs>
    with SingleTickerProviderStateMixin {
  late AnimationController? _iconController;
  bool collapsed = false;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    collapsed = widget.collapsed;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: InkWell(
            onTap: widget.isCollapsable
                ? () {
                    setState(() {
                      collapsed = !collapsed;
                      if (!collapsed) {
                        _iconController!.forward();
                      } else {
                        _iconController!.reverse();
                      }
                    });
                  }
                : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.section.title != null &&
                          widget.section.title!.isNotEmpty)
                        Text(
                          widget.section.title ?? '',
                          style: TextStyle(
                            color: widget.hasError ? Colors.red : widget.color,
                            fontSize: 24,
                          ),
                        ),
                      if (widget.section.subtitle != null &&
                          widget.section.subtitle!.isNotEmpty)
                        Text(
                          widget.section.subtitle ?? '',
                          style: const TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 16,
                          ),
                        ),
                    ],
                  ),
                ),
                Visibility(
                  visible: widget.isCollapsable,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: RotationTransition(
                      turns: Tween<double>(
                        begin: 0.0,
                        end: 0.5,
                      ).animate(_iconController!),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: widget.hasError ? Colors.red : Colors.grey[900],
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
            duration: const Duration(milliseconds: 450),
            curve: Curves.fastEaseInToSlowEaseOut,
            child: collapsed && widget.isCollapsable
                ? Container()
                : Column(
                    children: widget.section.fields
                        .map((D2BaseInputFieldConfig input) {
                      return ListenableBuilder(
                          listenable: widget.controller,
                          builder: (BuildContext context, Widget? child) {
                            D2FieldState fieldState =
                                widget.controller.getFieldState(input.name);

                            if (input is D2SelectInputFieldConfig) {
                              input.optionsToHide =
                                  widget.controller.optionsToHide[input.name];
                            }
                            return Visibility(
                              visible: !(fieldState.hidden ?? false),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: D2InputFieldContainer(
                                  input: input,
                                  onChange: fieldState.onChange,
                                  color: widget.color,
                                  error: fieldState.error,
                                  warning: fieldState.warning,
                                  value: fieldState.value,
                                  mandatory: fieldState.mandatory,
                                  disabled: (fieldState.disabled ?? false) ||
                                      widget.disabled,
                                ),
                              ),
                            );
                          });
                    }).toList(),
                  ))
      ],
    );
  }
}
