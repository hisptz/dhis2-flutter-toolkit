import 'expression_ast.dart';
import 'expression_context.dart';
import 'expression_functions.dart';
import 'expression_tokenizer.dart';

const Map<D2ExprTokenType, D2ExprBinaryOp> _comparisonOps = {
  D2ExprTokenType.eq: D2ExprBinaryOp.eq,
  D2ExprTokenType.ne: D2ExprBinaryOp.ne,
  D2ExprTokenType.lt: D2ExprBinaryOp.lt,
  D2ExprTokenType.le: D2ExprBinaryOp.le,
  D2ExprTokenType.gt: D2ExprBinaryOp.gt,
  D2ExprTokenType.ge: D2ExprBinaryOp.ge,
};

class D2ExpressionParser {
  final List<D2ExprToken> _tokens;
  int _pos = 0;

  D2ExpressionParser(String input)
    : _tokens = D2ExpressionTokenizer(input).tokenize();

  D2ExprNode parse() {
    final node = _parseOr();
    _expectEof();
    return node;
  }

  D2ExprToken get _current => _tokens[_pos];

  bool _check(D2ExprTokenType type) => _current.type == type;

  D2ExprToken _advance() {
    final token = _current;
    if (token.type != D2ExprTokenType.eof) _pos++;
    return token;
  }

  D2ExprToken _expect(D2ExprTokenType type, String what) {
    if (!_check(type)) {
      throw D2ExpressionException(
        'Expected $what but found "${_current.text}"',
      );
    }
    return _advance();
  }

  void _expectEof() {
    if (!_check(D2ExprTokenType.eof)) {
      throw D2ExpressionException('Unexpected token "${_current.text}"');
    }
  }

  D2ExprNode _parseOr() {
    var left = _parseAnd();
    while (_check(D2ExprTokenType.or)) {
      _advance();
      left = D2ExprBinary(D2ExprBinaryOp.or, left, _parseAnd());
    }
    return left;
  }

  D2ExprNode _parseAnd() {
    var left = _parseNot();
    while (_check(D2ExprTokenType.and)) {
      _advance();
      left = D2ExprBinary(D2ExprBinaryOp.and, left, _parseNot());
    }
    return left;
  }

  D2ExprNode _parseNot() {
    if (_check(D2ExprTokenType.not)) {
      _advance();
      return D2ExprUnary(D2ExprUnaryOp.not, _parseNot());
    }
    return _parseComparison();
  }

  D2ExprNode _parseComparison() {
    var left = _parseAddSub();
    while (_comparisonOps.containsKey(_current.type)) {
      final op = _comparisonOps[_advance().type]!;
      left = D2ExprBinary(op, left, _parseAddSub());
    }
    return left;
  }

  D2ExprNode _parseAddSub() {
    var left = _parseMulDiv();
    while (_check(D2ExprTokenType.plus) || _check(D2ExprTokenType.minus)) {
      final op = _advance().type == D2ExprTokenType.plus
          ? D2ExprBinaryOp.add
          : D2ExprBinaryOp.subtract;
      left = D2ExprBinary(op, left, _parseMulDiv());
    }
    return left;
  }

  D2ExprNode _parseMulDiv() {
    var left = _parseUnary();
    while (_check(D2ExprTokenType.star) || _check(D2ExprTokenType.slash)) {
      final op = _advance().type == D2ExprTokenType.star
          ? D2ExprBinaryOp.multiply
          : D2ExprBinaryOp.divide;
      left = D2ExprBinary(op, left, _parseUnary());
    }
    return left;
  }

  D2ExprNode _parseUnary() {
    if (_check(D2ExprTokenType.minus)) {
      _advance();
      return D2ExprUnary(D2ExprUnaryOp.minus, _parseUnary());
    }
    return _parsePrimary();
  }

  D2ExprNode _parsePrimary() {
    final token = _current;
    switch (token.type) {
      case D2ExprTokenType.number:
        _advance();
        return D2ExprNumber(double.tryParse(token.text) ?? 0.0);
      case D2ExprTokenType.string:
        _advance();
        return D2ExprString(token.text);
      case D2ExprTokenType.operand:
        _advance();
        return D2ExprOperand(token.text);
      case D2ExprTokenType.bracketLiteral:
        _advance();
        if (token.text == 'days') {
          return const D2ExprDays();
        }
        throw D2ExpressionException('Unsupported literal: [${token.text}]');
      case D2ExprTokenType.lparen:
        _advance();
        final inner = _parseOr();
        _expect(D2ExprTokenType.rparen, '")"');
        return inner;
      case D2ExprTokenType.identifier:
        return _parseIdentifierExpr();
      default:
        throw D2ExpressionException('Unexpected token "${token.text}"');
    }
  }

  D2ExprNode _parseIdentifierExpr() {
    final token = _advance();
    final name = token.text;

    if (_check(D2ExprTokenType.lparen)) {
      return _parseFunctionCall(name);
    }

    switch (name) {
      case 'true':
        return const D2ExprBool(true);
      case 'false':
        return const D2ExprBool(false);
      case 'null':
        return const D2ExprNullLiteral();
      default:
        throw D2ExpressionException('Unknown identifier "$name"');
    }
  }

  D2ExprNode _parseFunctionCall(String name) {
    _expect(D2ExprTokenType.lparen, '"("');

    if (name.startsWith('orgUnit.')) {
      final args = _parseOrgUnitUidArgs();
      _requireKnownFunction(name);
      return D2ExprFunctionCall(name, args);
    }

    if (name == 'is') {
      final args = _parseIsArgs();
      return D2ExprFunctionCall(name, args);
    }

    final args = <D2ExprNode>[];
    if (!_check(D2ExprTokenType.rparen)) {
      args.add(_parseOr());
      while (_check(D2ExprTokenType.comma)) {
        _advance();
        args.add(_parseOr());
      }
    }
    _expect(D2ExprTokenType.rparen, '")"');
    _requireKnownFunction(name);
    return D2ExprFunctionCall(name, args);
  }

  List<D2ExprNode> _parseIsArgs() {
    final tested = _parseOr();
    final inToken = _expect(D2ExprTokenType.identifier, '"in"');
    if (inToken.text != 'in') {
      throw D2ExpressionException('Expected "in" but found "${inToken.text}"');
    }
    final args = <D2ExprNode>[tested, _parseOr()];
    while (_check(D2ExprTokenType.comma)) {
      _advance();
      args.add(_parseOr());
    }
    _expect(D2ExprTokenType.rparen, '")"');
    return args;
  }

  List<D2ExprNode> _parseOrgUnitUidArgs() {
    final args = <D2ExprNode>[];
    if (!_check(D2ExprTokenType.rparen)) {
      args.add(_parseOrgUnitUid());
      while (_check(D2ExprTokenType.comma)) {
        _advance();
        args.add(_parseOrgUnitUid());
      }
    }
    _expect(D2ExprTokenType.rparen, '")"');
    return args;
  }

  D2ExprNode _parseOrgUnitUid() {
    final token = _expect(D2ExprTokenType.identifier, 'organisation unit UID');
    return D2ExprString(token.text);
  }

  void _requireKnownFunction(String name) {
    if (!d2ExpressionFunctions.containsKey(name)) {
      throw D2ExpressionException('Unsupported function: $name');
    }
  }
}
