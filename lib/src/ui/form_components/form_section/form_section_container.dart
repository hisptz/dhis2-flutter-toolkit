import 'package:flutter/material.dart';
import '../form/form_container.dart';
import '../input_field/input_field_container.dart';
import '../input_field/models/base_input_field.dart';
import 'models/form_section.dart';

// ignore: must_be_immutable
class FormSectionContainer extends StatefulWidget {
  final D2FormSection section;
  final OnFormFieldChange<String?> onFieldChange;
  final Color? color;
  final bool disabled;
  bool collapsed;
  bool hasError;
  final bool isCollapsable;

  FormSectionContainer(
      {super.key,
      required this.section,
      required this.onFieldChange,
      this.disabled = false,
      this.collapsed = false,
      this.hasError = false,
      this.isCollapsable = false,
      this.color});

  @override
  State<FormSectionContainer> createState() => _FormSectionContainerState();
}

class _FormSectionContainerState extends State<FormSectionContainer>
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
                      widget.section.title != null
                          ? Text(
                              widget.section.title!,
                              style: TextStyle(
                                color:
                                    widget.hasError ? Colors.red : widget.color,
                                fontSize: 24,
                              ),
                            )
                          : Container(),
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.0)),
                      widget.section.subtitle != null
                          ? Text(
                              widget.section.subtitle!,
                              style: const TextStyle(
                                  color: Colors.blueGrey, fontSize: 16),
                            )
                          : Container(),
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
        const Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
        AnimatedSize(
          duration: const Duration(milliseconds: 450),
          curve: Curves.fastEaseInToSlowEaseOut,
          child: collapsed && widget.isCollapsable
              ? Container()
              : Column(
                  children:
                      widget.section.fields.map((D2BaseInputFieldConfig input) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: D2InputFieldContainer(
                        disabled: widget.disabled,
                        input: input,
                        onChange: (value) {
                          return widget.onFieldChange(input.name, value);
                        },
                        color: widget.color,
                      ),
                    );
                  }).toList(),
                ),
        )
      ],
    );
  }
}
