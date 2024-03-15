///Copyright (c) 2024, HISP Tanzania Developers.
///All rights reserved. Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.

library;

import '../../d2_operations.dart';
import '../../mathematical_operations.dart';

//
///`ProgramRuleHelper` is a collection of helper functions for evaluation of a `ProgramRule`
//
class ProgramRuleHelper {
  //
  ///This is a helper function for evaluating the logical condition.
  ///It accepts the condition as a `String` and returns a `dynamic` value from the condition
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
  ///`evaluateLogicalConditionWithinBrackets` evaluates the atomic condition having none of the brackets in it.
  ///The function accepts a `String` condition and returns a `dynamic` evaluated value.
  //
  static dynamic evaluateLogicalConditionWithinBrackets(String condition) {
    return D2MathematicalOperations.evaluateMathematicalOperation(
      condition,
      resolveToNumber: false,
    );
  }

  //
  ///`sanitizeExpression` sanitizes the program rule expression by replacing the program rule variables with actual values
  ///function accepts `String` expression, `String` program rule variable name and a `String` value
  ///This function returns a sanitized `String` having the expression with replaced with appropriate values
  //
  static String sanitizeExpression({
    required String expression,
    required String programRuleVariable,
    required String value,
  }) {
    var regExString = RegExp('[AV#]{1}{$programRuleVariable}');
    return expression.split(regExString).join("'$value'");
  }
}
