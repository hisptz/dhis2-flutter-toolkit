import 'package:collection/collection.dart';
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:flutter/foundation.dart';

import '../../../../repositories/metadata/option_group.dart';
import '../../../../utils/program_rule_engine/models/program_rule_results.dart';
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

  void spawnProgramRuleEngine(List<String> inputFieldIds) async {
    ProgramRuleResult programRuleEvaluationResults =
        startProgramRuleEvaluation(inputFieldIds);
    updateFormStates(programRuleEvaluationResults);
  }

  ProgramRuleResult startProgramRuleEvaluation(List<String> inputFieldIds) {
    return programRuleEngine.evaluateProgramRule(
      inputFieldIds: inputFieldIds,
      formDataObject: formValues,
    );
  }

  void updateFormStates(ProgramRuleResult programRuleEvaluation) {
    if (programRuleEvaluation.hiddenFields.allFields.isNotEmpty) {
      programRuleEvaluation.hiddenFields.allFields.forEach((fieldKey, value) {
        if ((value == true && !isFieldHidden(fieldKey)) ||
            (value == false && isFieldHidden(fieldKey))) {
          toggleFieldVisibilitySilently(fieldKey);
          setValueSilently(fieldKey, null);
        }
      });
    }

    if (programRuleEvaluation.mandatoryFields.allFields.isNotEmpty) {
      programRuleEvaluation.mandatoryFields.allFields
          .forEach((fieldKey, value) {
        value == true
            ? addMandatoryFieldSilently(fieldKey)
            : clearFromMandatoryFieldSilently(fieldKey);
      });
    }

    if (programRuleEvaluation.hiddenSections.allSections.isNotEmpty) {
      programRuleEvaluation.hiddenSections.allSections
          .forEach((sectionKey, value) {
        if ((value == true && !isSectionHidden(sectionKey)) ||
            (value == false && isSectionHidden(sectionKey))) {
          toggleSectionVisibilitySilently(sectionKey);
        }
      });
    }

    if (programRuleEvaluation.assignedFields.allValues.isNotEmpty) {
      programRuleEvaluation.assignedFields.allValues.forEach((fieldKey, value) {
        disableFields([fieldKey]);
        setValueSilently(fieldKey, value);
      });
    }

    if (programRuleEvaluation.hiddenOptions.allOptions.isNotEmpty) {
      programRuleEvaluation.hiddenOptions.allOptions
          .forEach((inputFieldId, options) {
        List<Map<String, dynamic>> fieldHiddenOptions = [];
        for (var hiddenOption in options) {
          hiddenOption.forEach((optionKey, hiddenState) {
            var option = D2OptionRepository(db).getByUid(optionKey)?.code ?? '';
            fieldHiddenOptions
                .add({'option': option, 'hiddenState': hiddenState});
          });
        }
        _hideFieldOptions(inputFieldId, fieldHiddenOptions);
      });
    }

    if (programRuleEvaluation.hiddenOptionGroups.allOptionGroups.isNotEmpty) {
      programRuleEvaluation.hiddenOptionGroups.allOptionGroups
          .forEach((inputFieldId, optionGroups) {
        List<Map<String, dynamic>> fieldHiddenOptions = [];
        for (var hiddenOptionGroup in optionGroups) {
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
    }

    if (programRuleEvaluation.warningMessages.allMessages.isNotEmpty) {
      programRuleEvaluation.warningMessages.allMessages
          .forEach((fieldKey, warningMessages) {
        for (var warningMessage in warningMessages) {
          if (warningMessage.visibilityStatus == true) {
            setWarningSilently(fieldKey, warningMessage.message);
          } else {
            if (warningMessage.message == getWarning(fieldKey)) {
              clearWarningSilently(fieldKey);
            }
          }
        }
      });
    }

    if (programRuleEvaluation.errorMessages.allMessages.isNotEmpty) {
      programRuleEvaluation.errorMessages.allMessages
          .forEach((fieldKey, errorMessages) {
        for (var errorMessage in errorMessages) {
          if (errorMessage.visibilityStatus == true) {
            setErrorSilently(fieldKey, errorMessage.message);
          } else {
            if (errorMessage.message == getError(fieldKey)) {
              clearErrorSilently(fieldKey);
            }
          }
        }
      });
    }

    notifyListeners();
  }

  void runProgramRules() {
    spawnProgramRuleEngine(formFields.map((field) => field.name).toList());
  }

  @override
  void setValue(String key, value) {
    setValueSilently(key, value);
    runProgramRules();
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
