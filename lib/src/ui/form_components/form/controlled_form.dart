import 'package:collection/collection.dart';
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/form_section/form_section_container_with_controlled_inputs.dart';
import 'package:flutter/material.dart';

import '../state/section_state.dart';

class D2ControlledForm extends StatelessWidget {
  final D2Form form;
  final D2FormController controller;
  final Color? color;
  final bool disabled;
  final bool collapsableSections;

  D2ControlledForm(
      {super.key,
      required this.form,
      required this.controller,
      this.collapsableSections = false,
      this.color,
      this.disabled = false}) {
    List<D2BaseInputFieldConfig> formFields = [
      ...(form.sections?.map((section) => section.fields).flattened.toList() ??
          []),
      ...(form.fields ?? [])
    ];
    controller.setFormFields(formFields);
  }

  @override
  Widget build(BuildContext context) {
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
                children: form.sections!
                    .mapIndexed((int index, D2FormSection section) {
                return ListenableBuilder(
                  listenable: controller,
                  builder: (context, child) {
                    SectionState state =
                        controller.getSectionState(section.id, []);

                    List<D2FieldState> formFieldsState = section.fields
                        .map((field) => controller.getFieldState(field.name))
                        .toList();

                    // checks for hidden state of the section and the fields
                    bool hidden = (state.hidden ?? false) ||
                        formFieldsState
                            .every((fieldState) => fieldState.hidden ?? false);

                    // checks for errors of the section and the fields
                    bool hasError = (state.error ?? false) ||
                        formFieldsState
                            .any((fieldState) => fieldState.error != null);

                    bool collapsed = index != 0;

                    return Visibility(
                        visible: !hidden,
                        child: FormSectionContainerWithControlledInputs(
                          disabled: disabled,
                          wrapFields: form.wrapFields,
                          denseFields: form.denseFields,
                          section: section,
                          controller: controller,
                          collapsed: collapsed,
                          isCollapsable: collapsableSections,
                          hasError: hasError,
                          color: color,
                        ));
                  },
                );
              }).toList())
            : Column(
                children: form.fields!.map((D2BaseInputFieldConfig input) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: D2FormControlledInputField(
                    dense: form.denseFields,
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
