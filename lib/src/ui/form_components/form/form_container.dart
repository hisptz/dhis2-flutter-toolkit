import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/models/base_input_field.dart';
import 'package:flutter/material.dart';

typedef OnFormFieldChange<T> = void Function(String key, T);

class FormContainer extends StatelessWidget {
  final D2Form form;
  final Map<String, String?> errorState;
  final Map<String, String?> values;
  final Map<String, bool> mandatoryState;
  final Map<String, bool> hiddenState;

  final OnFormFieldChange<String?> onFormFieldChange;

  const FormContainer({
    super.key,
    required this.form,
    required this.errorState,
    required this.values,
    required this.mandatoryState,
    required this.hiddenState,
    required this.onFormFieldChange,
  });

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
                    color: form.color,
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
                    FormSection section = form.sections![index];
                    return FormSectionContainer(
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
                    return InputFieldContainer(
                      color: form.color,
                      input: input,
                      onChange: (String? value) =>
                          onFormFieldChange(input.name, value),
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
