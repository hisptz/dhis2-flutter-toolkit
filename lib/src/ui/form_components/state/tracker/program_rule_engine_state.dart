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
  abstract List<D2CustomProgramRule> customProgramRules;

  void spawnProgramRuleEngine(List<String> inputFieldIds) async {
    D2ProgramRuleResult programRuleEvaluationResults =
        startProgramRuleEvaluation(inputFieldIds);
    updateFormStates(programRuleEvaluationResults);
  }

  D2ProgramRuleResult startProgramRuleEvaluation(List<String> inputFieldIds) {
    return programRuleEngine.evaluateProgramRule(
      inputFieldIds: inputFieldIds,
      formDataObject: formValues,
    );
  }

  void _toggleFieldVisibility(
    String fieldKey,
    bool hiddenStatus,
  ) {
    if ((hiddenStatus == true && !isFieldHidden(fieldKey)) ||
        (hiddenStatus == false && isFieldHidden(fieldKey))) {
      toggleFieldVisibilitySilently(fieldKey);
      setValueSilently(fieldKey, null);
    }
  }

  void _toggleSectionVisibility(
    String sectionKey,
    bool hiddenStatus,
  ) {
    if ((hiddenStatus == true && !isSectionHidden(sectionKey)) ||
        (hiddenStatus == false && isSectionHidden(sectionKey))) {
      toggleSectionVisibilitySilently(sectionKey);
    }
  }

  void _toggleMandatoryField(
    String fieldKey,
    bool mandatoryStatus,
  ) {
    mandatoryStatus == true
        ? addMandatoryFieldSilently(fieldKey)
        : clearFromMandatoryFieldSilently(fieldKey);
  }

  void _assignFieldValue(
    String fieldKey,
    dynamic value,
  ) {
    disableFields([fieldKey]);
    setValueSilently(fieldKey, value);
  }

  void _setErrorMessage(
    String fieldKey,
    String message,
    bool visibilityStatus,
  ) {
    if (visibilityStatus == true) {
      setErrorSilently(fieldKey, message);
    } else {
      if (message == getError(fieldKey)) {
        clearErrorSilently(fieldKey);
      }
    }
  }

  void _setWarningMessage(
    String fieldKey,
    String message,
    bool visibilityStatus,
  ) {
    if (visibilityStatus == true) {
      setWarningSilently(fieldKey, message);
    } else {
      if (message == getWarning(fieldKey)) {
        clearWarningSilently(fieldKey);
      }
    }
  }

  void _hideOptions(
    String inputFieldId,
    List<String> optionCodes,
    bool hiddenState,
  ) {
    if (hiddenState == true) {
      setOptionsToHideSilently(inputFieldId, optionCodes);
    } else {
      removeOptionsToHideSilently(inputFieldId, optionCodes);
    }
  }

  void _hideFieldOptions(
    String inputFieldId,
    List<Map<String, dynamic>> fieldHiddenOptions,
  ) {
    groupBy(fieldHiddenOptions, (fieldOption) => fieldOption['hiddenState'])
        .forEach((hiddenState, options) {
      var optionCodes =
          options.map((option) => option['option'] as String).toList();
      if (optionCodes.contains(getValue(inputFieldId)) && hiddenState == true) {
        clearValueSilently(inputFieldId);
      }
      _hideOptions(inputFieldId, optionCodes, hiddenState);
    });
  }

  void updateFormStates(D2ProgramRuleResult programRuleEvaluation) {
    if (programRuleEvaluation.hiddenFields.allFields.isNotEmpty) {
      programRuleEvaluation.hiddenFields.allFields.forEach((fieldKey, value) {
        _toggleFieldVisibility(fieldKey, value);
      });
    }

    if (programRuleEvaluation.mandatoryFields.allFields.isNotEmpty) {
      programRuleEvaluation.mandatoryFields.allFields
          .forEach((fieldKey, value) {
        _toggleMandatoryField(fieldKey, value);
      });
    }

    if (programRuleEvaluation.hiddenSections.allSections.isNotEmpty) {
      programRuleEvaluation.hiddenSections.allSections
          .forEach((sectionKey, value) {
        _toggleSectionVisibility(sectionKey, value);
      });
    }

    if (programRuleEvaluation.assignedFields.allValues.isNotEmpty) {
      programRuleEvaluation.assignedFields.allValues.forEach((fieldKey, value) {
        _assignFieldValue(fieldKey, value);
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
          _setWarningMessage(
            fieldKey,
            warningMessage.message,
            warningMessage.visibilityStatus,
          );
        }
      });
    }

    if (programRuleEvaluation.errorMessages.allMessages.isNotEmpty) {
      programRuleEvaluation.errorMessages.allMessages
          .forEach((fieldKey, errorMessages) {
        for (var errorMessage in errorMessages) {
          _setErrorMessage(
            fieldKey,
            errorMessage.message,
            errorMessage.visibilityStatus,
          );
        }
      });
    }

    for (D2CustomProgramRule customProgramRule in customProgramRules) {
      // TODO handle custom rules
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
}
