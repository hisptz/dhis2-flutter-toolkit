import 'package:flutter/foundation.dart';

import '../../../../../objectbox.dart';
import '../../../../models/metadata/option.dart';
import '../../../../repositories/metadata/option.dart';
import '../../../../repositories/metadata/option_group.dart';
import '../../../../utils/program_rule_engine/program_rule_engine.dart';
import '../form_data_state.dart';
import '../form_disabled_state.dart';
import '../form_error_state.dart';
import '../form_hidden_state.dart';
import '../form_mandatory_state.dart';
import '../form_option_state.dart';
import '../form_value_state.dart';
import '../form_warning_state.dart';

class ProgramRuleEngineArguments {
  final D2ProgramRuleEngine programRuleEngine;
  final String inputFieldKey;

  ProgramRuleEngineArguments({
    required this.programRuleEngine,
    required this.inputFieldKey,
  });
}

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

  void spawnProgramRuleEngine(
      D2ProgramRuleEngine programRuleEngine, String inputFieldKey) async {
    ProgramRuleEngineArguments args = ProgramRuleEngineArguments(
      programRuleEngine: programRuleEngine,
      inputFieldKey: inputFieldKey,
    );
    Map programRuleEvaluationResults = startProgramRuleEvaluation(args);
    updateFormStates(programRuleEvaluationResults, inputFieldKey);
  }

  Map startProgramRuleEvaluation(ProgramRuleEngineArguments args) {
    return args.programRuleEngine.evaluateProgramRule(
      inputFieldId: args.inputFieldKey,
      formDataObject: formValues,
    );
  }

  void updateFormStates(Map programRuleEvaluation, String inputFieldKey) {
    programRuleEvaluation.forEach((actionProperty, fields) {
      if (actionProperty == 'assignedFields') {
        fields.forEach((fieldKey, value) {
          disableFields([fieldKey]);
          setValue(fieldKey, value);
        });
      } else if (actionProperty == 'hiddenFields') {
        fields.forEach((fieldKey, value) {
          if ((value == true && !isFieldHidden(fieldKey)) ||
              (value == false && isFieldHidden(fieldKey))) {
            toggleFieldVisibility(fieldKey);
            setValue(fieldKey, null);
          }
        });
      } else if (actionProperty == 'hiddenSections') {
        fields.forEach((sectionKey, value) {
          if ((value == true && !isSectionHidden(sectionKey)) ||
              (value == false && isSectionHidden(sectionKey))) {
            toggleSectionVisibility(sectionKey);
          }
        });
      } else if (actionProperty == 'warningMessages') {
        fields.forEach((fieldKey, value) {
          var hiddenStatus = value['hidden'] ?? false;
          if (hiddenStatus == true) {
            setWarning(fieldKey, value['message'] ?? '');
          } else {
            clearWarning(fieldKey);
          }
        });
      } else if (actionProperty == 'errorMessages') {
        fields.forEach((fieldKey, value) {
          var hiddenStatus = value['hidden'] ?? false;
          if (hiddenStatus == true) {
            setError(fieldKey, value['message'] ?? '');
          } else {
            clearError(fieldKey);
          }
        });
      } else if (actionProperty == 'errorMessages') {
        fields.forEach((fieldKey, value) {
          setError(fieldKey, value['message'] ?? '');
        });
      } else if (actionProperty == 'hiddenOptions') {
        fields.forEach((inputFieldId, options) {
          for (var hiddenOption in options) {
            hiddenOption.forEach((optionKey, hiddenState) {
              var option =
                  D2OptionRepository(db).getByUid(optionKey as String)?.code ??
                      '';
              if (hiddenState == true) {
                if (getValue(inputFieldId) == option) {
                  clearValue(inputFieldId);
                }
                setOptionsToHide(inputFieldId, [option]);
              } else {
                removeOptionsToHide(inputFieldId, [option]);
              }
            });
          }
        });
      } else if (actionProperty == 'hiddenOptionGroups') {
        fields.forEach((inputFieldId, optionGroups) {
          for (var hiddenOptionGroup in (optionGroups as List<Map>)) {
            hiddenOptionGroup.forEach((optionGroupKey, hiddenState) {
              var options = (D2OptionGroupRepository(db)
                          .getByUid(optionGroupKey)
                          ?.options ??
                      [] as List<D2Option>)
                  .map((D2Option option) => option.code)
                  .toList();

              if (hiddenState == true) {
                if (options.contains(getValue(inputFieldId))) {
                  clearValue(inputFieldId);
                }
                setOptionsToHide(inputFieldId, options);
              } else {
                removeOptionsToHide(inputFieldId, options);
              }
            });
          }
        });
      } else if (actionProperty == 'mandatoryFields') {
        fields.forEach((fieldKey, value) {
          value == true
              ? addMandatoryField(fieldKey)
              : clearFromMandatoryField(fieldKey);
        });
      }
    });
    notifyListeners();
  }
}
