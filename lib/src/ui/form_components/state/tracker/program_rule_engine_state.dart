import 'package:collection/collection.dart';
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:flutter/foundation.dart';

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

  // TODO find a better way for clearing state
  void clearHiddenStatesSilently() {
    clearHiddenFieldsSilently();
  }

  void spawnProgramRuleEngine(List<String> inputFieldIds) async {
    D2ProgramRuleResult programRuleEvaluationResults =
        startProgramRuleEvaluation(inputFieldIds);
    clearHiddenStatesSilently();
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
    if (hiddenStatus == true && !isFieldHidden(fieldKey)) {
      toggleFieldVisibilitySilently(fieldKey);
    }
  }

  void _toggleFieldDisable(
    String fieldKey,
    bool disabledStatus,
  ) {
    disabledStatus
        ? disableFieldsSilently([fieldKey])
        : clearDisabledField(fieldKey);
  }

  void _toggleSectionVisibility(
    String sectionKey,
    bool hiddenStatus,
  ) {
    if ((hiddenStatus == true && !isSectionHidden(sectionKey)) ||
        (hiddenStatus == false && isSectionHidden(sectionKey))) {
      toggleSectionVisibilitySilently(sectionKey);
    }

    D2ProgramSection? programSection =
        D2ProgramSectionRepository(db).getByUid(sectionKey);

    D2ProgramStageSection? programStageSection =
        D2ProgramStageSectionRepository(db).getByUid(sectionKey);

    //  clear the values of the fields in the section
    if (programSection != null) {
      for (var programSectionTrackedEntityAttribute
          in programSection.programSectionTrackedEntityAttributes) {
        String key = programSectionTrackedEntityAttribute
                .trackedEntityAttribute.target?.uid ??
            '';

        // hide the field if the section is hidden
        _toggleFieldVisibility(key, hiddenStatus);

        if (hiddenStatus == true) {
          setValueSilently(key, null);
        }
      }
    } else if (programStageSection != null) {
      for (var programStageDataElement
          in programStageSection.programStageSectionDataElements) {
        String key = programStageDataElement.dataElement.target?.uid ?? '';
        if (hiddenStatus == true) {
          setValueSilently(key, null);
        }
      }
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

  void _assignFieldValue(String fieldKey, dynamic value,
      {bool? disabledStatus}) {
    setValueSilently(fieldKey, value);
    if (disabledStatus != null) {
      _toggleFieldDisable(fieldKey, disabledStatus == true);
    }
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
    // Hide fields that are hidden by DHIS2 program rules
    if (programRuleEvaluation.hiddenFields.allFields.isNotEmpty) {
      programRuleEvaluation.hiddenFields.allFields.forEach((fieldKey, value) {
        _toggleFieldVisibility(fieldKey, value);
      });
    }

    // Set mandatory fields that are set mandatory by DHIS2 program rules
    if (programRuleEvaluation.mandatoryFields.allFields.isNotEmpty) {
      programRuleEvaluation.mandatoryFields.allFields
          .forEach((fieldKey, value) {
        _toggleMandatoryField(fieldKey, value);
      });
    }

    // Hide sections that are hidden by DHIS2 program rules
    if (programRuleEvaluation.hiddenSections.allSections.isNotEmpty) {
      programRuleEvaluation.hiddenSections.allSections
          .forEach((sectionKey, value) {
        _toggleSectionVisibility(sectionKey, value);
      });
    }

    // Assigned fields that are assigned by DHIS2 program rules
    if (programRuleEvaluation.assignedFields.allValues.isNotEmpty) {
      programRuleEvaluation.assignedFields.allValues.forEach((fieldKey, value) {
        _assignFieldValue(fieldKey, value, disabledStatus: true);
      });
    }

    // Hide options that are hidden by DHIS2 program rules
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

    // Hide option groups that are hidden by DHIS2 program rules
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

    // Set warning messages that are set by the DHIS2 program rules
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

    // Sett error messages that are set by the DHIS2 program rules
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

    // Process the custom program rules
    _executeCustomRules(customProgramRules, formValues);

    notifyListeners();
  }

  void _executeCustomRules(List<D2CustomProgramRule> d2CustomProgramRules,
      Map<String, dynamic> formValues) {
    for (D2CustomProgramRule customProgramRule in d2CustomProgramRules) {
      bool programRuleExpressionValue =
          customProgramRule.expressionFunction(formValues);
      for (D2CustomAction action in customProgramRule.actions) {
        if (action.hiddenField != null) {
          _toggleFieldVisibility(
            action.hiddenField!,
            programRuleExpressionValue,
          );
        }
        if (action.hiddenSection != null) {
          _toggleSectionVisibility(
            action.hiddenSection!,
            programRuleExpressionValue,
          );
        }
        if (action.hiddenOption != null) {
          _hideOptions(
            action.hiddenOption!.fieldId,
            [action.hiddenOption!.optionCode],
            programRuleExpressionValue,
          );
        }
        if (action.hiddenOptionGroup != null) {
          D2OptionGroup? optionGroup = D2OptionGroupRepository(db)
              .getByUid(action.hiddenOptionGroup!.optionGroupId);
          if (optionGroup != null) {
            List<String> optionsToHide =
                optionGroup.options.map((option) => option.code).toList();
            _hideOptions(
              action.hiddenOptionGroup!.fieldId,
              optionsToHide,
              programRuleExpressionValue,
            );
          }
        }
        if (action.disabledField != null) {
          _toggleFieldDisable(
            action.disabledField!,
            programRuleExpressionValue,
          );
        }
        if (action.error != null) {
          _setErrorMessage(
            action.error!.fieldId ?? '',
            action.error!.message ?? '',
            programRuleExpressionValue,
          );
        }
        if (action.warning != null) {
          _setWarningMessage(
            action.warning!.fieldId ?? '',
            action.warning!.message ?? '',
            programRuleExpressionValue,
          );
        }
        if (action.value != null && programRuleExpressionValue == true) {
          _assignFieldValue(
            action.value!.fieldId ?? '',
            action.value!.value,
            disabledStatus: action.value!.disable,
          );
        }
        if (action.setValue != null && programRuleExpressionValue == true) {
          FieldValue fieldValue = action.setValue!(formValues);
          _assignFieldValue(
            fieldValue.fieldId ?? '',
            fieldValue.value,
            disabledStatus: fieldValue.disable,
          );
        }
        if (action.mandatoryField != null) {
          _toggleMandatoryField(
            action.mandatoryField ?? '',
            programRuleExpressionValue,
          );
        }
      }
    }
  }

  void runProgramRules() {
    spawnProgramRuleEngine(formFields.map((field) => field.name).toList());
  }

  void runCustomProgramRulesOnly(
      List<D2CustomProgramRule> d2CustomProgramRules) {
    _executeCustomRules(d2CustomProgramRules, formValues);
    notifyListeners();
  }

  @override
  void setValue(String key, value) {
    setValueSilently(key, value);
    runProgramRules();
  }
}
