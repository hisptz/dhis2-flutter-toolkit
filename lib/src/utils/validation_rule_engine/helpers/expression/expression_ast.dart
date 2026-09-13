import 'expression_context.dart';
import 'expression_functions.dart';
import 'expression_value_utils.dart';

abstract class D2ExprNode {
  Object? eval(D2ExprEvalContext ctx);
}

class D2ExprNumber implements D2ExprNode {
  final double value;

  const D2ExprNumber(this.value);

  @override
  Object? eval(D2ExprEvalContext ctx) => value;
}

class D2ExprString implements D2ExprNode {
  final String value;

  const D2ExprString(this.value);

  @override
  Object? eval(D2ExprEvalContext ctx) => value;
}

class D2ExprBool implements D2ExprNode {
  final bool value;

  const D2ExprBool(this.value);

  @override
  Object? eval(D2ExprEvalContext ctx) => value;
}

/// The bare `null` literal. Per DHIS2 semantics this doesn't just evaluate
/// to `null` — it also disables further missing-value defaulting for the
/// rest of this expression (see [D2ExprEvalContext]).
class D2ExprNullLiteral implements D2ExprNode {
  const D2ExprNullLiteral();

  @override
  Object? eval(D2ExprEvalContext ctx) {
    ctx.replaceNulls = false;
    return null;
  }
}

/// A `#{uid.uid}` data value reference. A present value is type-sniffed
/// (numeric, then boolean, then left as text) since this package's
/// `dataValues` map carries raw strings with no attached DHIS2 value type.
/// A missing value defaults to `0.0` while [D2ExprEvalContext.replaceNulls]
/// is true, or surfaces as a genuine `null` when a caller (isNull,
/// isNotNull, firstNonNull) is asking specifically to see through defaults.
class D2ExprOperand implements D2ExprNode {
  final String key;

  const D2ExprOperand(this.key);

  @override
  Object? eval(D2ExprEvalContext ctx) {
    final raw = ctx.dataValues[key];
    if (raw == null || raw.trim().isEmpty) {
      return ctx.replaceNulls ? 0.0 : null;
    }

    final trimmed = raw.trim();
    final asDouble = double.tryParse(trimmed);
    if (asDouble != null) return asDouble;

    final lower = trimmed.toLowerCase();
    if (lower == 'true') return true;
    if (lower == 'false') return false;

    return trimmed;
  }
}

class D2ExprDays implements D2ExprNode {
  const D2ExprDays();

  @override
  Object? eval(D2ExprEvalContext ctx) => ctx.period?.daysInPeriod?.toDouble();
}

enum D2ExprUnaryOp { minus, not }

class D2ExprUnary implements D2ExprNode {
  final D2ExprUnaryOp op;
  final D2ExprNode operand;

  const D2ExprUnary(this.op, this.operand);

  @override
  Object? eval(D2ExprEvalContext ctx) {
    if (op == D2ExprUnaryOp.minus) {
      final value = d2CastDouble(operand.eval(ctx));
      return value == null ? null : -value;
    }
    final value = d2CastBoolean(operand.eval(ctx));
    return value == null ? null : !value;
  }
}

enum D2ExprBinaryOp {
  add,
  subtract,
  multiply,
  divide,
  eq,
  ne,
  lt,
  le,
  gt,
  ge,
  and,
  or,
}

class D2ExprBinary implements D2ExprNode {
  final D2ExprBinaryOp op;
  final D2ExprNode left;
  final D2ExprNode right;

  const D2ExprBinary(this.op, this.left, this.right);

  @override
  Object? eval(D2ExprEvalContext ctx) {
    switch (op) {
      case D2ExprBinaryOp.add:
      case D2ExprBinaryOp.subtract:
      case D2ExprBinaryOp.multiply:
      case D2ExprBinaryOp.divide:
        return _evalArithmetic(ctx);
      case D2ExprBinaryOp.eq:
        return d2Compare(left.eval(ctx), right.eval(ctx)) == 0;
      case D2ExprBinaryOp.ne:
        return d2Compare(left.eval(ctx), right.eval(ctx)) != 0;
      case D2ExprBinaryOp.lt:
        return d2Compare(left.eval(ctx), right.eval(ctx)) < 0;
      case D2ExprBinaryOp.le:
        return d2Compare(left.eval(ctx), right.eval(ctx)) <= 0;
      case D2ExprBinaryOp.gt:
        return d2Compare(left.eval(ctx), right.eval(ctx)) > 0;
      case D2ExprBinaryOp.ge:
        return d2Compare(left.eval(ctx), right.eval(ctx)) >= 0;
      case D2ExprBinaryOp.and:
        return _evalAnd(ctx);
      case D2ExprBinaryOp.or:
        return _evalOr(ctx);
    }
  }

  Object? _evalArithmetic(D2ExprEvalContext ctx) {
    final l = d2CastDouble(left.eval(ctx));
    final r = d2CastDouble(right.eval(ctx));
    if (l == null || r == null) return null;
    switch (op) {
      case D2ExprBinaryOp.add:
        return l + r;
      case D2ExprBinaryOp.subtract:
        return l - r;
      case D2ExprBinaryOp.multiply:
        return l * r;
      case D2ExprBinaryOp.divide:
        return r == 0 ? 0.0 : l / r;
      default:
        return null;
    }
  }

  bool? _evalAnd(D2ExprEvalContext ctx) {
    final l = d2CastBoolean(left.eval(ctx));
    if (l == false) return false;
    final r = d2CastBoolean(right.eval(ctx));
    if (l == null || r == null) return null;
    return l && r;
  }

  bool? _evalOr(D2ExprEvalContext ctx) {
    final l = d2CastBoolean(left.eval(ctx));
    if (l == true) return true;
    final r = d2CastBoolean(right.eval(ctx));
    if (l == null || r == null) return null;
    return l || r;
  }
}

class D2ExprFunctionCall implements D2ExprNode {
  final String name;
  final List<D2ExprNode> args;

  const D2ExprFunctionCall(this.name, this.args);

  @override
  Object? eval(D2ExprEvalContext ctx) {
    final impl = d2ExpressionFunctions[name];
    if (impl == null) {
      throw D2ExpressionException('Unsupported function: $name');
    }
    return impl(args, ctx);
  }
}
