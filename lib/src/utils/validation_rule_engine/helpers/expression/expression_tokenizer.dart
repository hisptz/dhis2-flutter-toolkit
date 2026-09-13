enum D2ExprTokenType {
  number,
  string,
  identifier,
  operand,
  bracketLiteral,
  lparen,
  rparen,
  comma,
  plus,
  minus,
  star,
  slash,
  eq,
  ne,
  lt,
  le,
  gt,
  ge,
  and,
  or,
  not,
  eof,
}

class D2ExprToken {
  final D2ExprTokenType type;
  final String text;

  const D2ExprToken(this.type, this.text);

  @override
  String toString() => '$type("$text")';
}

final RegExp _digitOrDot = RegExp(r'[0-9.]');
final RegExp _digit = RegExp(r'[0-9]');
final RegExp _identifierStart = RegExp(r'[A-Za-z_]');
final RegExp _identifierPart = RegExp(r'[A-Za-z0-9_.]');

class D2ExpressionTokenizer {
  final String _input;
  int _pos = 0;

  D2ExpressionTokenizer(this._input);

  List<D2ExprToken> tokenize() {
    final tokens = <D2ExprToken>[];
    while (true) {
      final token = _next();
      tokens.add(token);
      if (token.type == D2ExprTokenType.eof) break;
    }
    return tokens;
  }

  D2ExprToken _next() {
    _skipWhitespace();
    if (_pos >= _input.length) {
      return const D2ExprToken(D2ExprTokenType.eof, '');
    }

    final ch = _input[_pos];

    if (ch == '#' && _peek(1) == '{') {
      _pos += 2;
      final contentStart = _pos;
      while (_pos < _input.length && _input[_pos] != '}') {
        _pos++;
      }
      final content = _input.substring(contentStart, _pos);
      if (_pos < _input.length) _pos++;
      return D2ExprToken(D2ExprTokenType.operand, content);
    }

    // Bracket literals, e.g. `[days]` — the number of calendar days in
    // whatever period the expression is being evaluated for.
    if (ch == '[') {
      _pos++;
      final contentStart = _pos;
      while (_pos < _input.length && _input[_pos] != ']') {
        _pos++;
      }
      final content = _input.substring(contentStart, _pos);
      if (_pos < _input.length) _pos++;
      return D2ExprToken(D2ExprTokenType.bracketLiteral, content);
    }

    switch (ch) {
      case '(':
        _pos++;
        return const D2ExprToken(D2ExprTokenType.lparen, '(');
      case ')':
        _pos++;
        return const D2ExprToken(D2ExprTokenType.rparen, ')');
      case ',':
        _pos++;
        return const D2ExprToken(D2ExprTokenType.comma, ',');
      case '+':
        _pos++;
        return const D2ExprToken(D2ExprTokenType.plus, '+');
      case '-':
        _pos++;
        return const D2ExprToken(D2ExprTokenType.minus, '-');
      case '*':
        _pos++;
        return const D2ExprToken(D2ExprTokenType.star, '*');
      case '/':
        _pos++;
        return const D2ExprToken(D2ExprTokenType.slash, '/');
    }

    if (ch == '=' && _peek(1) == '=') {
      _pos += 2;
      return const D2ExprToken(D2ExprTokenType.eq, '==');
    }
    if (ch == '!' && _peek(1) == '=') {
      _pos += 2;
      return const D2ExprToken(D2ExprTokenType.ne, '!=');
    }
    if (ch == '!') {
      _pos++;
      return const D2ExprToken(D2ExprTokenType.not, '!');
    }
    if (ch == '<' && _peek(1) == '=') {
      _pos += 2;
      return const D2ExprToken(D2ExprTokenType.le, '<=');
    }
    if (ch == '<') {
      _pos++;
      return const D2ExprToken(D2ExprTokenType.lt, '<');
    }
    if (ch == '>' && _peek(1) == '=') {
      _pos += 2;
      return const D2ExprToken(D2ExprTokenType.ge, '>=');
    }
    if (ch == '>') {
      _pos++;
      return const D2ExprToken(D2ExprTokenType.gt, '>');
    }
    if (ch == '&' && _peek(1) == '&') {
      _pos += 2;
      return const D2ExprToken(D2ExprTokenType.and, '&&');
    }
    if (ch == '|' && _peek(1) == '|') {
      _pos += 2;
      return const D2ExprToken(D2ExprTokenType.or, '||');
    }

    if (ch == '"' || ch == "'") {
      final quote = ch;
      _pos++;
      final buffer = StringBuffer();
      while (_pos < _input.length && _input[_pos] != quote) {
        if (_input[_pos] == r'\' && _pos + 1 < _input.length) {
          _pos++;
        }
        buffer.write(_input[_pos]);
        _pos++;
      }
      if (_pos < _input.length) _pos++;
      return D2ExprToken(D2ExprTokenType.string, buffer.toString());
    }

    if (_digit.hasMatch(ch)) {
      final start = _pos;
      while (_pos < _input.length && _digitOrDot.hasMatch(_input[_pos])) {
        _pos++;
      }
      return D2ExprToken(D2ExprTokenType.number, _input.substring(start, _pos));
    }

    if (_identifierStart.hasMatch(ch)) {
      final start = _pos;
      while (_pos < _input.length && _identifierPart.hasMatch(_input[_pos])) {
        _pos++;
      }
      return D2ExprToken(
        D2ExprTokenType.identifier,
        _input.substring(start, _pos),
      );
    }

    _pos++;
    return _next();
  }

  String? _peek(int offset) {
    final idx = _pos + offset;
    return idx < _input.length ? _input[idx] : null;
  }

  void _skipWhitespace() {
    while (_pos < _input.length && _input[_pos].trim().isEmpty) {
      _pos++;
    }
  }
}
