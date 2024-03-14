import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:flutter/material.dart';

typedef OnFormFieldChange<T> = void Function(String key, T);

class FormContainer extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Color color;
  final List<FormSection> sections;
  final Map<String, String?> errorState;
  final Map<String, String?> values;
  final Map<String, bool> mandatoryState;
  final Map<String, bool> hiddenState;

  final OnFormFieldChange<String?> onFormFieldChange;

  const FormContainer(
      {super.key,
      this.title,
      this.subtitle,
      required this.color,
      required this.errorState,
      required this.values,
      required this.mandatoryState,
      required this.hiddenState,
      required this.onFormFieldChange,
      required this.sections});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title != null
              ? Text(
                  title!,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                )
              : Container(),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          subtitle != null
              ? Text(
                  subtitle!,
                  style: const TextStyle(color: Colors.blueGrey, fontSize: 16),
                )
              : Container(),
          const Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
          ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                FormSection section = sections[index];
                return FormSectionContainer(
                  section: section,
                  onFieldChange: onFormFieldChange,
                );
              },
              separatorBuilder: (context, index) => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
              itemCount: sections.length)
        ],
      ),
    );
  }
}
