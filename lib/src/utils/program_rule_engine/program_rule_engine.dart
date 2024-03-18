///Copyright (c) 2024, HISP Tanzania Developers.
///All rights reserved. Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.

library;

import 'package:flutter/foundation.dart';

import '../../constants/dhis2_variables.dart';
import '../../constants/string_constants.dart';
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
  List<D2ProgramRule> programRules;

  /// A list of `D2ProgramRuleVariable` to be used in evaluation of program rules
  List<D2ProgramRuleVariable> programRuleVariables;

  ///
  ///`D2ProgramRuleEngine` is constructor for the `D2ProgramRuleEngine` class
  /// The constructor takes a list of `D2ProgramRule` and a list of `D2ProgramRuleVariable` as required parameters
  ///
  D2ProgramRuleEngine({
    required this.programRules,
    required this.programRuleVariables,
  });

  ///`D2ProgramRuleEngine.evaluateProgramRule` is a helper function for evaluation of program rule on given form data object
  /// The function takes a list of `D2ProgramRule`, a list of `D2ProgramRuleVariable` and a `Map` of form data object to return a `Map` result
  /// The result from this function follows below format:
  ///```dart
  ///  {
  ///    "hiddenFields" : {...}
  ///    "assignedFields" : {...}
  ///    "hiddenSections" : {...}
  ///    "hiddenProgramStages" : {...}
  ///    "errorOrWarningMessage" : {...}
  ///  }
  ///```
  Map evaluateProgramRule({
    Map dataObject = const {},
  }) {
    var hiddenFields = {};
    var assignedFields = {};
    var hiddenSections = {};
    var hiddenProgramStages = {};
    var errorOrWarningMessage = {};

    List sortedProgramRules = _sortProgramRulesByPriority(programRules);

    if (sortedProgramRules.isNotEmpty) {
      for (D2ProgramRule programRule in sortedProgramRules) {
        String condition = programRule.condition;
        String sanitizedCondition = StringUtils.escapeCharacter(
          condition,
          escapeChar: StringConstants.escapedCharacters,
        );

        /// Decoding the expression with program rule variables
        sanitizedCondition = _decodeExpressionWithProgramRuleVariables(
          programRuleVariables: programRuleVariables,
          expression: sanitizedCondition,
          dataObject: dataObject,
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
              dataObject: dataObject,
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
                    dataObject: dataObject,
                  );
                  var evaluatedDataExpression =
                      ProgramRuleHelper.evaluateLogicalCondition(
                    sanitizedDataExpression,
                  );
                  var assignedValue = StringUtils.escapeQuotes(
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
                        ProgramRuleActionsConstants.showError ||
                    programRuleActionType ==
                        ProgramRuleActionsConstants.showWarning ||
                    programRuleActionType ==
                        ProgramRuleActionsConstants.warningOnComplete ||
                    programRuleActionType ==
                        ProgramRuleActionsConstants.errorOnComplete)) {
              String messageType = programRuleActionType ==
                          ProgramRuleActionsConstants.showError ||
                      programRuleActionType ==
                          ProgramRuleActionsConstants.errorOnComplete
                  ? 'error'
                  : 'warning';
              bool isOnComplete = programRuleActionType ==
                          ProgramRuleActionsConstants.warningOnComplete ||
                      programRuleActionType ==
                          ProgramRuleActionsConstants.errorOnComplete
                  ? true
                  : false;
              errorOrWarningMessage[dataItemTargetedByProgramAction] = {
                "message": content,
                "isComplete": isOnComplete,
                "messageType": messageType
              };
            } else if (evaluatedConditionResults.runtimeType == bool &&
                evaluatedConditionResults == true) {
              var message = '';
              String messageType = programRuleActionType ==
                          ProgramRuleActionsConstants.showError ||
                      programRuleActionType ==
                          ProgramRuleActionsConstants.errorOnComplete
                  ? 'error'
                  : 'warning';
              bool isOnComplete = programRuleActionType ==
                          ProgramRuleActionsConstants.warningOnComplete ||
                      programRuleActionType ==
                          ProgramRuleActionsConstants.errorOnComplete
                  ? true
                  : false;
              if (content != null) {
                message += content;
              }
              if (data != null) {
                message += ' $data';
              }
              errorOrWarningMessage[dataItemTargetedByProgramAction] = {
                message: message,
                isOnComplete: isOnComplete,
                messageType: messageType,
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
      "errorOrWarningMessage": errorOrWarningMessage
    };
  }

  //
  /// `D2ProgramRuleEngine.decodeExpressionWithProgramRuleVariables` is a helper function that decodes and expression by replacing data object values with the program rule variables
  /// The function accepts `String` expression, `Map` data object and a `List` of `D2ProgramRuleVariable` .
  /// It returns a sanitized `String` expression
  String _decodeExpressionWithProgramRuleVariables({
    required String expression,
    required List<D2ProgramRuleVariable> programRuleVariables,
    Map dataObject = const {},
  }) {
    String sanitizedExpression = expression;

    for (D2ProgramRuleVariable programRuleVariable in programRuleVariables) {
      var value = "''";
      if (sanitizedExpression.contains(programRuleVariable.name)) {
        String ruleVariableDataElementAttributeId =
            programRuleVariable.dataElement.target?.uid ??
                programRuleVariable.trackedEntityAttribute.target?.uid ??
                '';

        if (dataObject.isNotEmpty &&
            dataObject[ruleVariableDataElementAttributeId] != null) {
          try {
            double doubleValue = double.parse(
              dataObject[ruleVariableDataElementAttributeId] ?? '0.0',
            );
            value = doubleValue as String;
          } catch (error) {
            value = "${dataObject[ruleVariableDataElementAttributeId]}";
            if (dataObject[ruleVariableDataElementAttributeId] != '') {
              value = "${dataObject[ruleVariableDataElementAttributeId]}";
            }
          }
          sanitizedExpression = _escapeStandardDhis2Variables(
            dataObject: dataObject,
            expression: sanitizedExpression,
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
    Map dataObject = const {},
  }) {
    var dhis2Variables = Dhis2Variables.getStandardVariables();
    if (dhis2Variables.any(
      (variable) => expression.contains(variable),
    )) {
      for (var variable in dhis2Variables) {
        String sanitizedVariable =
            StringUtils.convertSnakeCaseToCamelCase(variable);
        expression = dataObject.keys.contains(sanitizedVariable)
            ? ProgramRuleHelper.sanitizeExpression(
                expression: expression,
                programRuleVariable: variable,
                value: dataObject[sanitizedVariable],
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
