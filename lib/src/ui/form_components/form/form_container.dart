import 'package:flutter/material.dart';

import '../form_section/form_section_container.dart';
import '../form_section/models/form_section.dart';
import '../input_field/input_field_container.dart';
import '../input_field/models/base_input_field.dart';
import 'models/form.dart';

typedef OnFormFieldChange<T> = void Function(String key, T);

/// This is a widget for rendering a [D2Form] with its fields and sections.
class FormContainer extends StatelessWidget {
  /// The form to be rendered.
  final D2Form form;

  /// The state of errors for each form field.
  final Map<String, String?> errorState;

  /// The current values of the form fields.
  final Map<String, String?> values;

  /// The state of mandatory fields.
  final Map<String, bool> mandatoryState;

  /// The state of hidden fields.
  final Map<String, bool> hiddenState;

  /// The primary color for the form elements.
  final Color? color;

  /// Indicates whether the form is disabled.
  final bool disabled;

  /// Callback for handling changes in form fields.
  final OnFormFieldChange<String?> onFormFieldChange;

  /// Constructs a [FormContainer] with the given parameters.
  ///
  /// - [form] The form to be rendered.
  /// - [errorState] The state of errors for each form field.
  /// - [values] The current values of the form fields.
  /// - [mandatoryState] The state of mandatory fields.
  /// - [hiddenState] The state of hidden fields.
  /// - [onFormFieldChange] Callback for handling changes in form fields.
  /// - [disabled] Indicates whether the form is disabled. Defaults to `false`.
  /// - [color] The primary color for the form elements.
  const FormContainer(
      {super.key,
      required this.form,
      required this.errorState,
      required this.values,
      required this.mandatoryState,
      required this.hiddenState,
      required this.onFormFieldChange,
      this.disabled = false,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          form.title != null
              ? Text(
                  form.title!,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                )
              : Container(),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          form.subtitle != null
              ? Text(
                  form.subtitle!,
                  style: const TextStyle(color: Colors.blueGrey, fontSize: 16),
                )
              : Container(),
          const Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
          form.sections != null
              ? ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    D2FormSection section = form.sections![index];
                    return FormSectionContainer(
                      disabled: disabled,
                      section: section,
                      onFieldChange: onFormFieldChange,
                    );
                  },
                  separatorBuilder: (context, index) => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                      ),
                  itemCount: form.sections!.length)
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    D2BaseInputFieldConfig input = form.fields![index];
                    return D2InputFieldContainer(
                      disabled: disabled,
                      color: color,
                      input: input,
                      onChange: (value) => onFormFieldChange(input.name, value),
                    );
                  },
                  separatorBuilder: (context, index) => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                      ),
                  itemCount: form.fields!.length)
        ],
      ),
    );
  }
}
