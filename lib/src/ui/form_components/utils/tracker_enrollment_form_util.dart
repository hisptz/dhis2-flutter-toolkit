import 'package:collection/collection.dart';

import '../../../models/metadata/option.dart';
import '../../../models/metadata/option_set.dart';
import '../../../models/metadata/program.dart';
import '../../../models/metadata/program_section.dart';
import '../../../models/metadata/program_tracked_entity_attribute.dart';
import '../../../models/metadata/tracked_entity_attribute.dart';
import '../form_section/models/form_section.dart';
import '../input_field/models/base_input_field.dart';
import '../input_field/models/date_input_field.dart';
import '../input_field/models/input_field_option.dart';
import '../input_field/models/input_field_type_enum.dart';
import '../input_field/models/select_input_field.dart';

class TrackerEnrollmentFormUtils {
  D2Program program;

  List<D2BaseInputFieldConfig> _getFields(
      List<D2TrackedEntityAttribute> attributes) {
    return attributes.map((D2TrackedEntityAttribute attribute) {
      D2ProgramTrackedEntityAttribute? programAttribute =
          program.programTrackedEntityAttributes.firstWhereOrNull(
              (D2ProgramTrackedEntityAttribute programAttribute) =>
                  programAttribute.trackedEntityAttribute.target?.uid ==
                  attribute.uid);

      if (programAttribute == null) {
        throw "Missing program attribute attribute for attribute ${attribute.uid}";
      }

      D2InputFieldType? type =
          D2InputFieldType.fromDHIS2ValueType(attribute.valueType);

      D2OptionSet? optionSet = attribute.optionSet.target;

      if (optionSet != null) {
        List<D2InputFieldOption> options = optionSet.options
            .map<D2InputFieldOption>((D2Option option) => D2InputFieldOption(
                code: option.code, name: option.displayName ?? option.name))
            .toList();
        return D2SelectInputFieldConfig(
            options: options,
            label: attribute.displayFormName ??
                attribute.displayName ??
                attribute.name,
            type: type!,
            name: attribute.uid,
            mandatory: programAttribute.mandatory);
      }

      return D2BaseInputFieldConfig(
          label: attribute.displayFormName ??
              attribute.displayName ??
              attribute.name,
          type: type!,
          name: attribute.uid,
          mandatory: programAttribute.mandatory);
    }).toList();
  }

  List<FormSection> _getFormSections() {
    return program.programSections
        .map<FormSection>((D2ProgramSection programSection) {
      List<D2BaseInputFieldConfig> fields =
          _getFields(programSection.trackedEntityAttributes);
      return FormSection(
          fields: fields,
          id: programSection.uid,
          color: options.color,
          title: programSection.displayName ?? programSection.name,
          subtitle: "");
    }).toList();
  }
}
