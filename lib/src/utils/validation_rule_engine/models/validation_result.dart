import '../../../models/metadata/validation_rule.dart';

class D2ValidationResult {
  final List<D2ValidationViolation> violations;

  D2ValidationResult({required this.violations});

  bool get hasViolations => violations.isNotEmpty;

  List<D2ValidationViolation> get highImportanceViolations =>
      violations.where((v) => v.rule.importance == 'HIGH').toList();

  List<D2ValidationViolation> get mediumImportanceViolations =>
      violations.where((v) => v.rule.importance == 'MEDIUM').toList();

  List<D2ValidationViolation> get lowImportanceViolations =>
      violations.where((v) => v.rule.importance == 'LOW').toList();
}

class D2ValidationViolation {
  final D2ValidationRule rule;
  final double leftSideValue;
  final double rightSideValue;

  D2ValidationViolation({
    required this.rule,
    required this.leftSideValue,
    required this.rightSideValue,
  });

  String get description {
    final instruction = rule.instruction;
    if (instruction != null && instruction.isNotEmpty) {
      return instruction;
    }
    return '${rule.leftSideDescription ?? "Left"} $_operatorSymbol ${rule.rightSideDescription ?? "Right"}';
  }

  String get _operatorSymbol {
    switch (rule.operator) {
      case 'equal_to':
        return '==';
      case 'not_equal_to':
        return '!=';
      case 'greater_than':
        return '>';
      case 'greater_than_or_equal_to':
        return '>=';
      case 'less_than':
        return '<';
      case 'less_than_or_equal_to':
        return '<=';
      case 'compulsory_pair':
        return '⇔ (compulsory pair)';
      case 'exclusive_pair':
        return '⊕ (exclusive pair)';
      default:
        return rule.operator;
    }
  }

  String get detailedMessage {
    return '$description\n'
        '${rule.leftSideDescription ?? "Left side"}: $leftSideValue '
        '$_operatorSymbol '
        '${rule.rightSideDescription ?? "Right side"}: $rightSideValue';
  }
}
