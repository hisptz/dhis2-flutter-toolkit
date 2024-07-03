import 'custom_action.dart';

typedef ExpressionFunction = bool Function(Map<String, dynamic> formValues);

class D2CustomProgramRule {
  ExpressionFunction expressionFunction;
  List<D2CustomAction> actions;

  D2CustomProgramRule({
    required this.expressionFunction,
    this.actions = const [],
  });

  @override
  String toString() {
    return 'D2CustomProgramRule(expression: $expressionFunction, actions: $actions)';
  }
}
