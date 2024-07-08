import 'package:collection/collection.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/form_section/form_section_container_with_controlled_inputs.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/form_controlled_field_container.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/models/base_input_field.dart';
import 'package:flutter/material.dart';
import '../form_section/models/form_section.dart';
import '../state/form_state.dart';
import '../state/section_state.dart';
import 'models/form.dart';

/// This is a widget for displaying a controlled form in DHIS2.
class D2ControlledForm extends StatelessWidget {
  /// The form to display.
  final D2Form form;

  /// The controller for the form.
  final D2FormController controller;

  /// The color of the form.
  final Color? color;

  /// Indicates whether the form is disabled.
  final bool disabled;

  /// Constructs a new instance of [D2ControlledForm].
  ///
  /// - [form] The form to display.
  /// - [controller] The controller for the form.
  /// - [color] The color of the form.
  /// - [disabled] Indicates whether the form is disabled. Defaults to `false`.
  const D2ControlledForm(
      {super.key,
      required this.form,
      required this.controller,
      this.color,
      this.disabled = false});

  @override
  Widget build(BuildContext context) {
    List<D2BaseInputFieldConfig> formFields = [
      ...(form.sections?.map((section) => section.fields).flattened.toList() ??
          []),
      ...(form.fields ?? [])
    ];

    controller.setFormFields(formFields);

    return Column(
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
        form.subtitle != null
            ? Text(
                form.subtitle!,
                style: const TextStyle(color: Colors.blueGrey, fontSize: 16),
              )
            : Container(),
        form.sections != null
            ? Column(
                children: form.sections!.map((D2FormSection section) {
                return ListenableBuilder(
                  listenable: controller,
                  builder: (context, child) {
                    SectionState state =
                        controller.getSectionState(section.id, []);
                    return Visibility(
                        visible: !(state.hidden ?? false),
                        child: child ?? Container());
                  },
                  child: FormSectionContainerWithControlledInputs(
                    disabled: disabled,
                    section: section,
                    controller: controller,
                    color: color,
                  ),
                );
              }).toList())
            : Column(
                children: form.fields!.map((D2BaseInputFieldConfig input) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: D2FormControlledInputField(
                    disabled: disabled,
                    color: color,
                    input: input,
                    controller: controller,
                  ),
                );
              }).toList())
      ],
    );
  }
}
