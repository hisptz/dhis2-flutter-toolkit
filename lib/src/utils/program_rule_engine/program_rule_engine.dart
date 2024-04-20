///Copyright (c) 2024, HISP Tanzania Developers.
///All rights reserved. Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.

library;

import 'package:flutter/foundation.dart';

import '../../constants/dhis2_variables.dart';
import '../../constants/string_constants.dart';
import '../../models/data/tracked_entity.dart';
import '../../models/metadata/program_rule.dart';
import '../../models/metadata/program_rule_action.dart';
import '../../models/metadata/program_rule_variable.dart';
import '../string_utils.dart';
import './constants/program_rule_actions_constants.dart';
import './exceptions/program_rule_exception.dart';
import './helpers/program_rule_helper.dart';

///
///`D2ProgramRuleEngine` is the engine class for evaluation of DHI2 program rules
///
class D2ProgramRuleEngine {
  /// A list of `D2ProgramRule` to be evaluated
  final List<D2ProgramRule> programRules;

  /// A list of `D2ProgramRuleVariable` to be used in evaluation of program rules
  final List<D2ProgramRuleVariable> programRuleVariables;

  final D2TrackedEntity? trackedEntity;

  @override
  String toString() {
    return 'D2ProgramRuleEngine{programRules: $programRules, programRuleVariables: $programRuleVariables}';
  }

  ///
  ///`D2ProgramRuleEngine` is constructor for the `D2ProgramRuleEngine` class
  /// The constructor takes a list of `D2ProgramRule` and a list of `D2ProgramRuleVariable` as required parameters and an optional `D2TrackedEntity` object
  ///
  D2ProgramRuleEngine({
    required this.programRules,
    required this.programRuleVariables,
    this.trackedEntity,
  });

  ///`D2ProgramRuleEngine.evaluateProgramRule` is a helper function for evaluation of program rule on given form data object
  /// The function takes aa `Map` of form data object and an optional `String` id of the input field in current evaluations to return a `Map` result
  /// The result from this function follows below format:
  ///```dart
  ///  {
  ///    "hiddenFields" : {...}
  ///    "assignedFields" : {...}
  ///    "hiddenSections" : {...}
  ///    "hiddenProgramStages" : {...}
  ///    "errorMessages" : {...}
  ///    "warningMessages" : {...}
  ///  }
  ///```
  Map evaluateProgramRule({
    Map formDataObject = const {},
    String inputFieldId = '',
  }) {
    var hiddenFields = {};
    var assignedFields = {};
    var hiddenSections = {};
    var hiddenProgramStages = {};
    var errorMessages = {};
    var warningMessages = {};

    List<D2ProgramRule> sortedProgramRules = _sortProgramRulesByPriority(
      inputFieldId.isEmpty
          ? programRules
          : _filterProgramRulesByFieldId(inputFieldId),
    );

    if (sortedProgramRules.isNotEmpty) {
      for (D2ProgramRule programRule in sortedProgramRules) {
        String condition = programRule.condition;
        String sanitizedCondition = D2StringUtils.escapeCharacter(
          condition,
          escapeChar: StringConstants.escapedCharacters,
        );

        /// Decoding the expression with program rule variables
        sanitizedCondition = _decodeExpressionWithProgramRuleVariables(
          programRuleVariables: programRuleVariables,
          expression: sanitizedCondition,
          formDataObject: formDataObject,
        );

        try {
          /// Evaluating the logical condition
          var evaluatedConditionResults =
              ProgramRuleHelper.evaluateLogicalCondition(sanitizedCondition);

          for (D2ProgramRuleAction programRuleAction
              in programRule.programRuleActions) {
            String? data = programRuleAction.data;
            String? content = programRuleAction.content;
            String dataExpression = programRuleAction.data ?? '';
            String? programRuleActionType =
                programRuleAction.programRuleActionType;
            String dataElement =
                programRuleAction.dataElement.target?.uid ?? '';
            String trackedEntityAttribute =
                programRuleAction.trackedEntityAttribute.target?.uid ?? '';
            String programStageSection =
                programRuleAction.programStageSection.target?.uid ?? '';

            String dataItemTargetedByProgramAction = dataElement.isNotEmpty
                ? dataElement
                : trackedEntityAttribute.isNotEmpty
                    ? trackedEntityAttribute
                    : programStageSection.isNotEmpty
                        ? programStageSection
                        : '';

            /// Decoding the expression with program rule variables
            dataExpression = _decodeExpressionWithProgramRuleVariables(
              programRuleVariables: programRuleVariables,
              expression: dataExpression,
              formDataObject: formDataObject,
            );
            if (programRuleActionType ==
                    ProgramRuleActionsConstants.hideField &&
                evaluatedConditionResults.runtimeType == bool) {
              hiddenFields[dataItemTargetedByProgramAction] =
                  evaluatedConditionResults;
            } else if (programRuleActionType ==
                    ProgramRuleActionsConstants.assignField &&
                evaluatedConditionResults.runtimeType == bool) {
              if (dataItemTargetedByProgramAction.isNotEmpty) {
                if (evaluatedConditionResults) {
                  var sanitizedDataExpression = _escapeStandardDhis2Variables(
                    expression: dataExpression,
                    formDataObject: formDataObject,
                  );
                  var evaluatedDataExpression =
                      ProgramRuleHelper.evaluateLogicalCondition(
                    sanitizedDataExpression,
                  );
                  var assignedValue = D2StringUtils.escapeQuotes(
                    '$evaluatedDataExpression',
                  );
                  assignedFields[dataItemTargetedByProgramAction] =
                      assignedValue;
                }
              }
            } else if (programRuleActionType ==
                    ProgramRuleActionsConstants.hideSection &&
                evaluatedConditionResults.runtimeType == bool) {
              if (programStageSection.isNotEmpty == true) {
                String sectionId = programStageSection;
                hiddenSections[sectionId] = evaluatedConditionResults;
              }
            } else if (evaluatedConditionResults.runtimeType == bool &&
                evaluatedConditionResults == true &&
                (programRuleActionType ==
                        ProgramRuleActionsConstants.showWarning ||
                    programRuleActionType ==
                        ProgramRuleActionsConstants.warningOnComplete)) {
              bool isOnComplete = programRuleActionType ==
                          ProgramRuleActionsConstants.warningOnComplete ||
                      programRuleActionType ==
                          ProgramRuleActionsConstants.errorOnComplete
                  ? true
                  : false;
              warningMessages[dataItemTargetedByProgramAction] = {
                "message": content,
                "isComplete": isOnComplete,
              };
            } else if (evaluatedConditionResults.runtimeType == bool &&
                evaluatedConditionResults == true &&
                (programRuleActionType ==
                        ProgramRuleActionsConstants.showError ||
                    programRuleActionType ==
                        ProgramRuleActionsConstants.errorOnComplete)) {
              bool isOnComplete = programRuleActionType ==
                          ProgramRuleActionsConstants.warningOnComplete ||
                      programRuleActionType ==
                          ProgramRuleActionsConstants.errorOnComplete
                  ? true
                  : false;
              errorMessages[dataItemTargetedByProgramAction] = {
                "message": content,
                "isComplete": isOnComplete,
              };
            } else if (evaluatedConditionResults.runtimeType == bool &&
                evaluatedConditionResults == true) {
              var message = '';
              if (content != null) {
                message += content;
              }
              if (data != null) {
                message += ' $data';
              }
              errorMessages[dataItemTargetedByProgramAction] = {
                message: message,
              };
            }
          }
        } catch (error) {
          var exception = ProgramRuleException(
              'evaluateProgramRule(${programRule.id}): $error');
          debugPrint(exception.toString());
        }
      }
    }

    return {
      "hiddenFields": hiddenFields,
      "assignedFields": assignedFields,
      "hiddenSections": hiddenSections,
      "hiddenProgramStages": hiddenProgramStages,
      "warningMessages": warningMessages,
      "errorMessages": errorMessages
    };
  }

  /// `D2ProgramRuleEngine._filterProgramRulesByFieldId` is a private helper function that filters the program rules by the input field id
  /// The function accepts a `String` input field id
  /// The function returns a filtered `List` of `D2ProgramRule`
  List<D2ProgramRule> _filterProgramRulesByFieldId(String inputFields) {
    List<String> inputFieldProgramRuleVariables = programRuleVariables
        .where((programVariable) =>
            programVariable.dataElement.target?.uid == inputFields ||
            programVariable.trackedEntityAttribute.target?.uid == inputFields)
        .map((programVariable) => programVariable.name)
        .toList();

    return programRules
        .where((programRule) => inputFieldProgramRuleVariables
            .any((String variable) => programRule.condition.contains(variable)))
        .toList();
  }

  //
  /// `D2ProgramRuleEngine._decodeExpressionWithProgramRuleVariables` is a helper function that decodes and expression by replacing data object values with the program rule variables
  /// The function accepts `String` expression, `Map` data object and a `List` of `D2ProgramRuleVariable` .
  /// It returns a sanitized `String` expression
  String _decodeExpressionWithProgramRuleVariables(
      {required String expression,
      required List<D2ProgramRuleVariable> programRuleVariables,
      Map formDataObject = const {}}) {
    String sanitizedExpression = expression;

    // TODO Find better means for handling the standard variables as properties of tracked entities or events
    // Sanitizing the expression by removing DHIS2 standard variables
    sanitizedExpression = _escapeStandardDhis2Variables(
      formDataObject: formDataObject,
      expression: sanitizedExpression,
    );

    for (D2ProgramRuleVariable programRuleVariable in programRuleVariables) {
      var value = "''";
      if (sanitizedExpression.contains(programRuleVariable.name)) {
        if (trackedEntity != null) {
          value = ProgramRuleHelper
              .getProgramVariableValueFromTrackedEntityInstance(
            programRuleVariable: programRuleVariable,
            trackedEntity: trackedEntity!,
            formDataObject: formDataObject,
          );
        } else {
          value = ProgramRuleHelper.getProgramVariableValueFromFormDataObject(
            programRuleVariable: programRuleVariable,
            formDataObject: formDataObject,
          );
        }
        sanitizedExpression = ProgramRuleHelper.sanitizeExpression(
          expression: sanitizedExpression,
          programRuleVariable: programRuleVariable.name,
          value: value,
        );
      }
    }
    return sanitizedExpression;
  }

  //
  /// Replacing the DHIS2 standard variables with values from data object
  //
  String _escapeStandardDhis2Variables({
    String expression = '',
    Map formDataObject = const {},
  }) {
    var dhis2Variables = Dhis2Variables.getStandardVariables();
    if (dhis2Variables.any(
      (variable) => expression.contains(variable),
    )) {
      for (var variable in dhis2Variables) {
        String sanitizedVariable =
            D2StringUtils.convertSnakeCaseToCamelCase(variable);
        expression = formDataObject.keys.contains(sanitizedVariable)
            ? ProgramRuleHelper.sanitizeExpression(
                expression: expression,
                programRuleVariable: variable,
                value: formDataObject[sanitizedVariable],
              )
            : expression;
      }
    }

    return expression;
  }

  //
  /// `D2ProgramRuleEngine._sortProgramRulesByPriority` is a  private helper function that sorts the program rules by priority
  /// The function accepts a `List` of `D2ProgramRule` and returns a sorted `List` of `D2ProgramRule`
  /// The function returns a sorted `List` of `D2ProgramRule`
  //
  List<D2ProgramRule> _sortProgramRulesByPriority(
      List<D2ProgramRule> programRules) {
    var prioritizedProgramRules = programRules
        .where((programRule) => programRule.priority != null)
        .toList();
    prioritizedProgramRules.sort((firstProgramRule, secondProgramRule) =>
        firstProgramRule.priority!.compareTo(secondProgramRule.priority!));
    return [
      ...prioritizedProgramRules,
      ...(programRules
          .where((programRule) => programRule.priority == null)
          .toList())
    ];
  }
}