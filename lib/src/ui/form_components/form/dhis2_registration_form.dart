import 'package:collection/collection.dart';
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/form/models/dhis2_form_options.dart';
import 'package:flutter/material.dart';

class D2TrackerRegistrationForm extends StatelessWidget {
  final D2FormController controller;
  final D2Program program;
  final D2TrackerRegistrationFormOptions options;

  const D2TrackerRegistrationForm(
      {super.key,
      required this.controller,
      required this.program,
      required this.options});

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

      InputFieldType? type =
          InputFieldType.fromDHIS2ValueType(attribute.valueType);

      D2OptionSet? optionSet = attribute.optionSet.target;

      List<InputFieldOption>? options = optionSet?.options
          .map((D2Option option) => InputFieldOption(
              code: option.code, name: option.displayName ?? option.name))
          .toList();

      return InputField(
          label: attribute.displayFormName ??
              attribute.displayName ??
              attribute.name,
          type: type!,
          name: attribute.uid,
          options: options,
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
          color: options.color,
          title: programSection.displayName ?? programSection.name,
          subtitle: "");
    }).toList();
  }

  FormSection _getMetaFormSection() {
    return FormSection(
        id: "meta",
        fields: [
          InputField(
              name: "enrolledAt",
              mandatory: true,
              type: InputFieldType.date,
              label:
                  "Registration Date" //TODO: Get this value from program config
              ),
          InputField(
              name: "orgUnit",
              mandatory: true,
              type: InputFieldType.organisationUnit,
              label:
                  "Registration Org unit" //TODO: Get this value from program config
              )
        ],
        color: options.color);
  }

  @override
  Widget build(BuildContext context) {
    return D2ControlledForm(
        form: D2Form(
            color: options.color,
            title: options.showTitle
                ? program.displayName ?? program.shortName
                : null,
            sections: [
              ...(options.showRegistrationMetaInfo
                  ? [_getMetaFormSection()]
                  : []),
              ..._getFormSections()
            ]),
        controller: controller);
  }
}
