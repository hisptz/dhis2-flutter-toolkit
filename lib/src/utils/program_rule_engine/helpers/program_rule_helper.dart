/// Copyright (c) 2024, HISP Tanzania Developers.
/// All rights reserved. Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.

library;

import '../../../models/data/tracked_entity.dart';
import '../../../models/metadata/program_rule_variable.dart';
import '../../d2_operations.dart';
import '../../mathematical_operations.dart';
import '../constants/program_rule_variables.dart';

//
/// `ProgramRuleHelper` is a collection of helper functions for evaluation of a `ProgramRule`
//
class ProgramRuleHelper {
  //
  /// This is a helper function for evaluating the logical condition.
  /// It accepts the condition as a `String` and returns a `dynamic` value from the condition
  //
  static dynamic evaluateLogicalCondition(String condition) {
    condition = D2Operations.evaluatedD2BuiltInFunctions(condition);
    if (condition.contains('(') || condition.contains(')')) {
      int startIndex = condition.lastIndexOf('(');
      int endIndex = condition.indexOf(')', startIndex);
      String subCondition = condition.substring(startIndex, endIndex + 1);
      var value = evaluateLogicalConditionWithinBrackets(
          subCondition.replaceAll('(', '').replaceAll(')', ''));
      return evaluateLogicalCondition(
          condition.replaceAll(subCondition, '$value'));
    } else {
      var value = evaluateLogicalConditionWithinBrackets(condition);
      return value;
    }
  }

  //
  /// `evaluateLogicalConditionWithinBrackets` evaluates the atomic condition having none of the brackets in it.
  /// The function accepts a `String` condition and returns a `dynamic` evaluated value.
  //
  static dynamic evaluateLogicalConditionWithinBrackets(String condition) {
    return D2MathematicalOperations.evaluateMathematicalOperation(
      condition,
      resolveToNumber: false,
    );
  }

  //
  /// `sanitizeExpression` sanitizes the program rule expression by replacing the program rule variables with actual values
  /// function accepts `String` expression, `String` program rule variable name and a `String` value
  /// This function returns a sanitized `String` having the expression with replaced with appropriate values
  //
  static String sanitizeExpression({
    required String expression,
    required String programRuleVariable,
    required String value,
  }) {
    var regExString = RegExp('[AV#]{1}{$programRuleVariable}');
    return expression.split(regExString).join("'$value'");
  }

  //
  /// `getProgramVariableValueFromFormDataObject` gets the value of a program rule variable from the form data object
  /// The function accepts a `D2ProgramRuleVariable` and a `Map` of form data object
  /// This function returns a `String` value of the program rule variable
  ///
  static String getProgramVariableValueFromFormDataObject({
    required D2ProgramRuleVariable programRuleVariable,
    Map<dynamic, dynamic> formDataObject = const {},
  }) {
    var value = "''";
    String ruleVariableDataElementAttributeId =
        programRuleVariable.dataElement.target?.uid ??
            programRuleVariable.trackedEntityAttribute.target?.uid ??
            '';

    if (formDataObject.isNotEmpty &&
        formDataObject[ruleVariableDataElementAttributeId] != null) {
      try {
        double doubleValue = double.parse(
          formDataObject[ruleVariableDataElementAttributeId] ?? '0.0',
        );
        value = doubleValue as String;
      } catch (error) {
        value = "${formDataObject[ruleVariableDataElementAttributeId]}";
        if (formDataObject[ruleVariableDataElementAttributeId] != '') {
          value = "${formDataObject[ruleVariableDataElementAttributeId]}";
        }
      }
    }
    return value;
  }

  static String getProgramVariableValueFromTrackedEntityInstance({
    required D2ProgramRuleVariable programRuleVariable,
    required D2TrackedEntity trackedEntity,
    Map<dynamic, dynamic> formDataObject = const {},
  }) {
    var program = programRuleVariable.program.target?.uid ?? "";
    var programStage = programRuleVariable.programStage.target?.uid ?? "";
    var trackedEntityAttribute =
        programRuleVariable.trackedEntityAttribute.target?.uid ?? "";
    var dataElement = programRuleVariable.dataElement.target?.uid ?? "";

    var events = trackedEntity.events
        .where((element) => element.program.target?.uid == program)
        .toList();
    events.sort((event1, event2) =>
        (event1.occurredAt != null && event2.occurredAt != null)
            ? event2.occurredAt!.compareTo(event1.occurredAt!) // Reverse order
            : 0);

    var value = getProgramVariableValueFromFormDataObject(
      programRuleVariable: programRuleVariable,
      formDataObject: formDataObject,
    );

    if (ProgramRuleVariableSourceTypes.supportedTypes
        .contains(programRuleVariable.programRuleVariableSourceType)) {
      // for data element newest event program
      if (programRuleVariable.programRuleVariableSourceType ==
          ProgramRuleVariableSourceTypes.dataElementNewestEventProgram) {
        var programEvents = events
            .where((element) => element.program.target?.uid == program)
            .toList();

        if (programEvents.isNotEmpty) {
          var programEvent = programEvents.first;
          var dataValues = programEvent.dataValues.where(
            (element) => element.dataElement.target?.uid == dataElement,
          );

          if (dataValues.isNotEmpty) {
            value = dataValues.first.value ?? "''";
          }
        }
      }

      // for tracked entity instance attribute
      else if (programRuleVariable.programRuleVariableSourceType ==
          ProgramRuleVariableSourceTypes.teiAttribute) {
        if (trackedEntityAttribute.isNotEmpty) {
          var teiAttributeWithValue = trackedEntity.attributes
              .where(
                (element) =>
                    element.trackedEntityAttribute.target?.uid ==
                    trackedEntityAttribute,
              )
              .toList();

          if (teiAttributeWithValue.isNotEmpty) {
            value = value == "''"
                ? teiAttributeWithValue.first.value ?? "''"
                : value;
          }
        }
      }

      // for data element current event
      else if (programRuleVariable.programRuleVariableSourceType ==
          ProgramRuleVariableSourceTypes.dataElementCurrentEvent) {
        // Pass for the mean time, as value comes from the form data Object
        // TODO check if can extract current event. As of current it takes values from the form data object
        value = value;
      }

      // for data element newest event program stage
      else if (programRuleVariable.programRuleVariableSourceType ==
          ProgramRuleVariableSourceTypes.dataElementNewestEventProgramStage) {
        var programStageEvents = events.where(
            (element) => element.programStage.target?.uid == programStage);

        if (programStageEvents.isNotEmpty) {
          var programStageEvent = programStageEvents.first;
          var dataValue = programStageEvent.dataValues
              .firstWhere(
                (element) => element.dataElement.target?.uid == dataElement,
              )
              .value;
          value = value == "''" ? dataValue ?? "''" : value;
        }
      }
    } else {
      throw Exception(
          'Program rule variable source type <${programRuleVariable.programRuleVariableSourceType}> for ${programRuleVariable.name} is not supported by the Library');
    }
    return value;
  }
}
