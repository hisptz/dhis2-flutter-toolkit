import 'package:dhis2_flutter_toolkit/src/ui/form_components/form_section/form_section_container_with_controlled_inputs.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/form_controlled_field_container.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/models/base_input_field.dart';
import 'package:flutter/material.dart';

import '../form_section/models/form_section.dart';
import '../state/form_state.dart';
import 'models/form.dart';

class D2ControlledForm extends StatelessWidget {
  final D2Form form;
  final D2FormController controller;
  final Color? color;
  final bool disabled;

  const D2ControlledForm(
      {super.key,
      required this.form,
      required this.controller,
      this.color,
      this.disabled = false});

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
          form.subtitle != null
              ? Text(
                  form.subtitle!,
                  style: const TextStyle(color: Colors.blueGrey, fontSize: 16),
                )
              : Container(),
          form.sections != null
              ? ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    D2FormSection section = form.sections![index];
                    return FormSectionContainerWithControlledInputs(
                      disabled: disabled,
                      section: section,
                      controller: controller,
                      color: color,
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
                    return D2FormControlledInputField(
                      disabled: disabled,
                      color: color,
                      input: input,
                      controller: controller,
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
