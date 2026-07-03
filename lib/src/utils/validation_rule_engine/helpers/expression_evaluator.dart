class ExpressionEvaluator {
  static final RegExp _operandPattern = RegExp(r'#\{([^}]+)\}');

  static List<String> extractOperands(String expression) {
    return _operandPattern
        .allMatches(expression)
        .map((m) => m.group(1)!)
        .toList();
  }

  static double? evaluate(
    String expression,
    Map<String, String> dataValues,
    String missingValueStrategy,
  ) {
    String resolved = expression.replaceAllMapped(_operandPattern, (match) {
      final operandKey = match.group(1)!;
      final rawValue = dataValues[operandKey];

      if (rawValue == null || rawValue.trim().isEmpty) {
        return '0';
      }

      final parsed = double.tryParse(rawValue.trim());
      return (parsed ?? 0).toString();
    });

    try {
      return _ExpressionParser(resolved).parseExpression();
    } catch (e) {
      return null;
    }
  }
}

class _ExpressionParser {
  final String _input;
  int _pos = 0;

  _ExpressionParser(this._input);

  double parseExpression() {
    final result = _parseAddSub();
    return result;
  }

  double _parseAddSub() {
    var left = _parseMulDiv();
    while (_pos < _input.length) {
      _skipWhitespace();
      if (_pos >= _input.length) break;
      final op = _input[_pos];
      if (op == '+' || op == '-') {
        _pos++;
        final right = _parseMulDiv();
        left = op == '+' ? left + right : left - right;
      } else {
        break;
      }
    }
    return left;
  }

  double _parseMulDiv() {
    var left = _parseUnary();
    while (_pos < _input.length) {
      _skipWhitespace();
      if (_pos >= _input.length) break;
      final op = _input[_pos];
      if (op == '*' || op == '/') {
        _pos++;
        final right = _parseUnary();
        left = op == '*' ? left * right : (right != 0 ? left / right : 0);
      } else {
        break;
      }
    }
    return left;
  }

  double _parseUnary() {
    _skipWhitespace();
    if (_pos < _input.length && _input[_pos] == '-') {
      _pos++;
      return -_parsePrimary();
    }
    return _parsePrimary();
  }

  double _parsePrimary() {
    _skipWhitespace();
    if (_pos < _input.length && _input[_pos] == '(') {
      _pos++;
      final result = _parseAddSub();
      _skipWhitespace();
      if (_pos < _input.length && _input[_pos] == ')') {
        _pos++;
      }
      return result;
    }
    return _parseNumber();
  }

  double _parseNumber() {
    _skipWhitespace();
    final start = _pos;
    while (_pos < _input.length && RegExp(r'[0-9.]').hasMatch(_input[_pos])) {
      _pos++;
    }
    if (start == _pos) return 0;
    return double.tryParse(_input.substring(start, _pos)) ?? 0;
  }

  void _skipWhitespace() {
    while (_pos < _input.length && _input[_pos] == ' ') {
      _pos++;
    }
  }
}
