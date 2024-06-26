import 'package:flutter/material.dart';

import '../form/form_container.dart';
import '../input_field/input_field_container.dart';
import '../input_field/models/base_input_field.dart';
import 'models/form_section.dart';

/// This is a widget for rendering a [D2FormSection] with its fields.
class FormSectionContainer extends StatelessWidget {
  /// The section to be rendered.
  final D2FormSection section;

  /// Callback for handling changes in form fields.
  final OnFormFieldChange<String?> onFieldChange;

  /// The primary color for the section elements.
  final Color? color;

  /// Indicates whether the section is disabled.
  final bool disabled;

  /// Constructs a [FormSectionContainer] with the given parameters.
  ///
  /// - [section] The section to be rendered.
  /// - [onFieldChange] Callback for handling changes in form fields.
  /// - [disabled] Indicates whether the section is disabled. Defaults to `false`.
  /// - [color] The primary color for the section elements.
  const FormSectionContainer(
      {super.key,
      required this.section,
      required this.onFieldChange,
      this.disabled = false,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        section.title != null
            ? Text(
                section.title!,
                style: TextStyle(
                  color: color,
                  fontSize: 24,
                ),
              )
            : Container(),
        const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
        section.subtitle != null
            ? Text(
                section.subtitle!,
                style: const TextStyle(color: Colors.blueGrey, fontSize: 16),
              )
            : Container(),
        const Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
        Column(
          children: section.fields.map((D2BaseInputFieldConfig input) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: D2InputFieldContainer(
                disabled: disabled,
                input: input,
                onChange: (value) {
                  return onFieldChange(input.name, value);
                },
                color: color,
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}
