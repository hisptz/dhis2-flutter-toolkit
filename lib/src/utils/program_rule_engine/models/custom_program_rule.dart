import 'custom_action.dart';

class D2CustomProgramRule {
  bool expression;
  List<D2CustomAction> actions;

  D2CustomProgramRule({
    required this.expression,
    this.actions = const [],
  });

  @override
  String toString() {
    return 'D2CustomProgramRule(expression: $expression, actions: $actions)';
  }
}
