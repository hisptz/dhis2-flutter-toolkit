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

/// This is a utility class for handling enrollment form configuration and sections.
class D2TrackerEnrollmentFormUtil {
  /// The program associated with the form utility.
  D2Program program;

  /// Options for configuring the form utility.
  D2TrackerFormOptions options;

  /// Database instance used for data operations.
  D2ObjectBox db;

  /// Constructs a new [D2TrackerEnrollmentFormUtil].
  ///
  /// - [program] The program associated with the form utility.
  /// - [options] Options for configuring the form utility.
  /// - [db] Database instance used for data operations.
  D2TrackerEnrollmentFormUtil(
      {required this.program, required this.options, required this.db});

  /// Retrieves the list of form field configurations based on tracked entity attributes.
  ///
  /// - [attributes] List of tracked entity attributes.
  ///
  /// Returns a list of [D2BaseInputFieldConfig]
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

      return D2FormUtils.getFieldConfigFromDataItem(attribute,
          mandatory: programAttribute.mandatory,
          allowFutureDates: programAttribute.allowFutureDate,
          renderOptionsAsRadio: programAttribute.renderOptionsAsRadio,
          clearable: options.clearable);
    }).toList();
  }

  /// Retrieves the list of form sections based on program sections.
  ///
  /// Returns a list of [D2FormSection]
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

  /// Retrieves the form sections.
  get formSections {
    return _getFormSections();
  }
}
