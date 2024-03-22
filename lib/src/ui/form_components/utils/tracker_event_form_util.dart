import 'package:collection/collection.dart';
import 'package:dhis2_flutter_toolkit/src/models/metadata/program_stage_data_element.dart';
import 'package:dhis2_flutter_toolkit/src/models/metadata/program_stage_section.dart';
import 'package:dhis2_flutter_toolkit/src/models/metadata/program_stage_section_data_element.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/utils/form_utils.dart';

import '../../../models/metadata/data_element.dart';
import '../../../models/metadata/program_stage.dart';
import '../form_section/models/form_section.dart';
import '../input_field/models/base_input_field.dart';

class TrackerEventFormUtil {
  D2ProgramStage programStage;

  TrackerEventFormUtil({required this.programStage});

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

      return FormUtils.getFieldConfigFromDataItem(dataElement,
          mandatory: programStageDataElement.compulsory,
          allowFutureDates: programStageDataElement.allowFutureDate,
          renderOptionsAsRadio: programStageDataElement.renderOptionsAsRadio);
    }).toList();
  }

  List<D2FormSection> _getFormSections() {
    return programStage.programStageSections
        .map<D2FormSection>((D2ProgramStageSection programStageSection) {
      List<D2ProgramStageSectionDataElement> programStageSectionDataElement =
          programStageSection.programStageSectionDataElements
              .sorted((a, b) => a.sortOrder.compareTo(b.sortOrder));
      List<D2DataElement> dataElements = programStageSectionDataElement
          .map((element) => element.dataElement.target!)
          .toList();
      List<D2BaseInputFieldConfig> fields = _getFields(dataElements);
      return D2FormSection(
          fields: fields,
          id: programStageSection.uid,
          title: programStageSection.displayName ?? programStageSection.name,
          subtitle: "");
    }).toList();
  }

  get formSections {
    return _getFormSections();
  }
}
