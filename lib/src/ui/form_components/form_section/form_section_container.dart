import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:flutter/material.dart';

class FormSectionContainer extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<InputField> fields;
  final Color color;

  const FormSectionContainer(
      {super.key,
      required this.title,
      this.subtitle,
      required this.fields,
      required this.color});

  void onChange(String key, String? value) {}

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 24,
          ),
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
        subtitle != null
            ? Text(
                subtitle!,
                style: const TextStyle(color: Colors.blueGrey, fontSize: 16),
              )
            : Container(),
        const Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
        ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              InputField input = fields[index];
              return InputFieldContainer(
                  input: input,
                  onChange: (String? value) {
                    return onChange(input.name, value);
                  },
                  color: color);
            },
            separatorBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                ),
            itemCount: fields.length)
      ],
    );
  }
}
