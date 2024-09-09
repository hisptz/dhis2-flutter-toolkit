import 'package:collection/collection.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/utils/form_utils.dart';

import '../../../../objectbox.dart';
import '../../../models/metadata/program.dart';
import '../../../models/metadata/program_section.dart';
import '../../../models/metadata/program_tracked_entity_attribute.dart';
import '../../../models/metadata/tracked_entity_attribute.dart';
import '../form/models/dhis2_form_options.dart';
import '../form_section/models/form_section.dart';
import '../input_field/models/base_input_field.dart';

class D2TrackerEnrollmentFormUtil {
  D2Program program;
  D2TrackerFormOptions options;
  D2ObjectBox db;

  D2TrackerEnrollmentFormUtil(
      {required this.program, required this.options, required this.db});

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

      return D2FormUtils.getFieldConfigFromDataItem(
        attribute,
        mandatory: programAttribute.mandatory,
        allowFutureDates: programAttribute.allowFutureDate,
        renderOptionsAsRadio: programAttribute.renderOptionsAsRadio,
        clearable: options.clearable,
        db: db,
      );
    }).toList();
  }

  List<D2FormSection> _getFormSections() {
    return program.programSections
        .map<D2FormSection>((D2ProgramSection programSection) {
          List<D2BaseInputFieldConfig> fields = _getFields(programSection
              .programSectionTrackedEntityAttributes
              .sorted((a, b) => a.sortOrder.compareTo(b.sortOrder))
              .map((e) => e.trackedEntityAttribute.target!)
              .toList());
          return D2FormSection(
            fields: fields,
            id: programSection.uid,
            sortOrder: programSection.sortOrder ?? 0,
            title: options.showSectionTitle
                ? programSection.displayName ?? programSection.name
                : null,
            subtitle: "",
          );
        })
        .sorted((a, b) => a.sortOrder.compareTo(b.sortOrder))
        .toList();
  }

  get formSections {
    return _getFormSections();
  }
}
