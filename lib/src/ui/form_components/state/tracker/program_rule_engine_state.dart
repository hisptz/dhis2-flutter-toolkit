import 'package:collection/collection.dart';
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:flutter/foundation.dart';

import '../../../../repositories/metadata/option_group.dart';
import '../form_data_state.dart';
import '../form_disabled_state.dart';
import '../form_error_state.dart';
import '../form_hidden_state.dart';
import '../form_mandatory_state.dart';
import '../form_option_state.dart';
import '../form_value_state.dart';
import '../form_warning_state.dart';

mixin ProgramRuleEngineState
    on
        ChangeNotifier,
        D2FormHiddenState,
        D2FormDisabledState,
        D2FormWarningState,
        D2FormMandatoryState,
        D2FormOptionState,
        D2FormValueState,
        D2FormErrorState,
        D2FormDataState {
  abstract D2ObjectBox db;
  abstract D2ProgramRuleEngine programRuleEngine;

  void spawnProgramRuleEngine(String inputFieldKey) async {
    Map programRuleEvaluationResults =
        startProgramRuleEvaluation(inputFieldKey);
    updateFormStates(programRuleEvaluationResults, inputFieldKey);
  }

  Map startProgramRuleEvaluation(String key) {
    return programRuleEngine.evaluateProgramRule(
      inputFieldId: key,
      formDataObject: formValues,
    );
  }

  void updateFormStates(Map programRuleEvaluation, String inputFieldKey) {
    programRuleEvaluation.forEach((actionProperty, fields) {
      if (actionProperty == 'assignedFields') {
        fields.forEach((fieldKey, value) {
          disableFields([fieldKey]);
          setValueSilently(fieldKey, value);
        });
      } else if (actionProperty == 'hiddenFields') {
        fields.forEach((fieldKey, value) {
          if ((value == true && !isFieldHidden(fieldKey)) ||
              (value == false && isFieldHidden(fieldKey))) {
            toggleFieldVisibilitySilently(fieldKey);
            setValueSilently(fieldKey, null);
          }
        });
      } else if (actionProperty == 'hiddenSections') {
        fields.forEach((sectionKey, value) {
          if ((value == true && !isSectionHidden(sectionKey)) ||
              (value == false && isSectionHidden(sectionKey))) {
            toggleSectionVisibilitySilently(sectionKey);
          }
        });
      } else if (actionProperty == 'warningMessages') {
        fields.forEach((fieldKey, value) {
          var visibilityStatus = value['visibilityStatus'] ?? false;
          if (visibilityStatus == true) {
            setWarningSilently(fieldKey, value['message'] ?? '');
          } else {
            if (value['message'] == getWarning(fieldKey)) {
              clearWarningSilently(fieldKey);
            }
          }
        });
      } else if (actionProperty == 'errorMessages') {
        fields.forEach((fieldKey, value) {
          var visibilityStatus = value['visibilityStatus'] ?? false;
          if (visibilityStatus == true) {
            setErrorSilently(fieldKey, value['message'] ?? '');
          } else {
            if (value['message'] == getError(fieldKey)) {
              clearErrorSilently(fieldKey);
            }
          }
        });
      } else if (actionProperty == 'hiddenOptions') {
        fields.forEach((inputFieldId, options) {
          List<Map<String, dynamic>> fieldHiddenOptions = [];
          for (var hiddenOption in options) {
            hiddenOption.forEach((optionKey, hiddenState) {
              var option =
                  D2OptionRepository(db).getByUid(optionKey as String)?.code ??
                      '';
              fieldHiddenOptions
                  .add({'option': option, 'hiddenState': hiddenState});
            });
          }
          _hideFieldOptions(inputFieldId, fieldHiddenOptions);
        });
      } else if (actionProperty == 'hiddenOptionGroups') {
        fields.forEach((inputFieldId, optionGroups) {
          List<Map<String, dynamic>> fieldHiddenOptions = [];
          for (var hiddenOptionGroup in (optionGroups as List<Map>)) {
            hiddenOptionGroup.forEach((optionGroupKey, hiddenState) {
              var options = (D2OptionGroupRepository(db)
                          .getByUid(optionGroupKey)
                          ?.options ??
                      [] as List<D2Option>)
                  .map((D2Option option) => option.code)
                  .toList();
              for (String option in options) {
                fieldHiddenOptions
                    .add({'option': option, 'hiddenState': hiddenState});
              }
            });
          }
          _hideFieldOptions(inputFieldId, fieldHiddenOptions);
        });
      } else if (actionProperty == 'mandatoryFields') {
        fields.forEach((fieldKey, value) {
          value == true
              ? addMandatoryFieldSilently(fieldKey)
              : clearFromMandatoryFieldSilently(fieldKey);
        });
      }
    });
    notifyListeners();
  }

  void _hideFieldOptions(
      String inputFieldId, List<Map<String, dynamic>> fieldHiddenOptions) {
    groupBy(fieldHiddenOptions, (fieldOption) => fieldOption['hiddenState'])
        .forEach((hiddenState, options) {
      var optionCodes =
          options.map((option) => option['option'] as String).toList();
      if (optionCodes.contains(getValue(inputFieldId)) && hiddenState == true) {
        clearValueSilently(inputFieldId);
      }
      if (hiddenState == true) {
        setOptionsToHideSilently(inputFieldId, optionCodes);
      } else {
        removeOptionsToHideSilently(inputFieldId, optionCodes);
      }
    });
  }
}
