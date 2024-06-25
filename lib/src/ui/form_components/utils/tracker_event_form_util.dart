import 'package:collection/collection.dart';
import 'package:dhis2_flutter_toolkit/src/models/metadata/program_stage_data_element.dart';
import 'package:dhis2_flutter_toolkit/src/models/metadata/program_stage_section.dart';
import 'package:dhis2_flutter_toolkit/src/models/metadata/program_stage_section_data_element.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/utils/form_utils.dart';

import '../../../../objectbox.dart';
import '../../../models/metadata/data_element.dart';
import '../../../models/metadata/program_stage.dart';
import '../form/models/dhis2_form_options.dart';
import '../form_section/models/form_section.dart';
import '../input_field/models/base_input_field.dart';

/// This is a utility class for constructing form sections and fields for a tracker event form.
class D2TrackerEventFormUtil {
  /// Program stage associated with the form.
  D2ProgramStage programStage;

  /// Options for configuring the form.
  D2TrackerFormOptions options;

  /// Database instance used for data operations.
  D2ObjectBox db;

  /// Constructs a new [D2TrackerEventFormUtil] instance.
  ///
  /// - [programStage] Program stage associated with the form.
  ///
  /// - [options] Options for configuring the form.
  /// - [db] Database instance used for data operations.
  D2TrackerEventFormUtil(
      {required this.programStage, required this.options, required this.db});

  /// Retrieves form fields based on data elements associated with the program stage.
  ///
  /// - [dataElements] List of data elements to generate fields for.
  ///
  /// Returns a list of [D2BaseInputFieldConfig]
  List<D2BaseInputFieldConfig> _getFields(List<D2DataElement> dataElements) {
    return dataElements.map((D2DataElement dataElement) {
      D2ProgramStageDataElement? programStageDataElement =
          programStage.programStageDataElements.firstWhereOrNull(
              (D2ProgramStageDataElement programStageDataElement) =>
                  programStageDataElement.dataElement.target?.uid ==
                  dataElement.uid);

      if (programStageDataElement == null) {
        throw "Missing program attribute attribute for attribute ${dataElement.uid}";
      }

      return D2FormUtils.getFieldConfigFromDataItem(dataElement,
          db: db,
          mandatory: programStageDataElement.compulsory,
          allowFutureDates: programStageDataElement.allowFutureDate,
          renderOptionsAsRadio: programStageDataElement.renderOptionsAsRadio)
        ..clearable = options.clearable;
    }).toList();
  }

  /// Retrieves form sections based on program stage sections.
  ///
  /// Returns a list of [D2FormSection]
  List<D2FormSection> _getFormSections() {
    return programStage.programStageSections
        .map<D2FormSection>((D2ProgramStageSection programStageSection) {
          List<D2ProgramStageSectionDataElement>
              programStageSectionDataElement = programStageSection
                  .programStageSectionDataElements
                  .sorted((a, b) => a.sortOrder.compareTo(b.sortOrder));
          List<D2DataElement> dataElements = programStageSectionDataElement
              .map((element) => element.dataElement.target!)
              .toList();
          List<D2BaseInputFieldConfig> fields = _getFields(dataElements);
          return D2FormSection(
            fields: fields,
            id: programStageSection.uid,
            sortOrder: programStageSection.sortOrder ?? 0,
            title: options.showSectionTitle
                ? programStageSection.displayName ?? programStageSection.name
                : null,
            subtitle: "",
          );
        })
        .sorted((a, b) => a.sortOrder.compareTo(b.sortOrder))
        .toList();
  }

  /// Retrieves form sections for the tracker event form.
  get formSections {
    return _getFormSections();
  }
}
