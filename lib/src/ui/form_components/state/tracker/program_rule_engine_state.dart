import 'package:flutter/foundation.dart';

import '../../../../utils/program_rule_engine/program_rule_engine.dart';
import '../form_data_state.dart';
import '../form_disabled_state.dart';
import '../form_error_state.dart';
import '../form_hidden_state.dart';
import '../form_mandatory_state.dart';
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
        D2FormValueState,
        D2FormErrorState,
        D2FormDataState {
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
          setWarning(fieldKey, value['message'] ?? '');
        });
      } else if (actionProperty == 'errorMessages') {
        fields.forEach((fieldKey, value) {
          setError(fieldKey, value['message'] ?? '');
        });
      }
    });
    notifyListeners();
  }
}
