import 'package:collection/collection.dart';
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:flutter/material.dart';

class D2TrackerRegistrationForm extends StatelessWidget {
  final D2FormController controller;
  final D2Program program;
  final bool showRegistrationDateField;
  final Color color;

  const D2TrackerRegistrationForm(
      {super.key,
      required this.controller,
      required this.program,
      this.showRegistrationDateField = true,
      required this.color});

  List<InputField> _getFields(List<D2TrackedEntityAttribute> attributes) {
    return attributes.map((D2TrackedEntityAttribute attribute) {
      D2ProgramTrackedEntityAttribute? programAttribute =
          program.programTrackedEntityAttributes.firstWhereOrNull(
              (D2ProgramTrackedEntityAttribute programAttribute) =>
                  programAttribute.trackedEntityAttribute.target?.uid ==
                  attribute.uid);

      if (programAttribute == null) {
        throw "Missing program attribute attribute for attribute ${attribute.uid}";
      }

      return InputField(
          label: attribute.displayFormName ??
              attribute.displayName ??
              attribute.name,
          type: InputFieldType.fromName(attribute.valueType)!,
          name: attribute.uid,
          mandatory: programAttribute.mandatory);
    }).toList();
  }

  List<FormSection> _getFormSections() {
    return program.programSections.map((D2ProgramSection programSection) {
      List<InputField> fields =
          _getFields(programSection.trackedEntityAttributes);
      return FormSection(
          fields: fields,
          id: programSection.uid,
          color: color,
          title: programSection.displayName,
          subtitle: "");
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return D2ControlledForm(
        form: D2Form(
            color: color,
            title: program.displayName,
            sections: _getFormSections()),
        controller: controller);
  }
}
