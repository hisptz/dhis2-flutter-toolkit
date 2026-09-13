import 'package:dhis2_flutter_toolkit/src/repositories/metadata/data_set.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/metadata/org_unit_group.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/metadata/program.dart';

import 'expression_ast.dart';
import 'expression_context.dart';
import 'expression_value_utils.dart';

typedef D2ExprFunctionImpl =
    Object? Function(List<D2ExprNode> args, D2ExprEvalContext ctx);

final Map<String, D2ExprFunctionImpl> d2ExpressionFunctions = {
  'contains': _contains,
  'containsItems': _containsItems,
  'if': _if,
  'is': _is,
  'isNull': _isNull,
  'isNotNull': _isNotNull,
  'firstNonNull': _firstNonNull,
  'greatest': _greatest,
  'least': _least,
  'log': _log,
  'log10': _log10,
  'removeZeros': _removeZeros,
  'orgUnit.ancestor': _orgUnitAncestor,
  'orgUnit.dataSet': _orgUnitDataSet,
  'orgUnit.group': _orgUnitGroup,
  'orgUnit.program': _orgUnitProgram,
};

/// `contains(expr, sub1, ...)` — true iff every substring is found
/// (case-sensitive, plain substring match) in the first argument.
bool _contains(List<D2ExprNode> args, D2ExprEvalContext ctx) {
  final haystack = d2CastString(args[0].eval(ctx));
  for (var i = 1; i < args.length; i++) {
    if (!haystack.contains(d2CastString(args[i].eval(ctx)))) return false;
  }
  return true;
}

/// `containsItems(expr, item1, ...)` — the first argument is a
/// comma-separated list (as stored for multi-valued data elements); true
/// iff every subsequent argument is an exact member of that list.
bool _containsItems(List<D2ExprNode> args, D2ExprEvalContext ctx) {
  final items = d2CastString(args[0].eval(ctx)).split(',').toSet();
  for (var i = 1; i < args.length; i++) {
    if (!items.contains(d2CastString(args[i].eval(ctx)))) return false;
  }
  return true;
}

/// `if(cond, trueExpr, falseExpr)` — lazily evaluates only the taken
/// branch. A `null` condition (only reachable when nulls aren't being
/// auto-defaulted) yields `null`, not a default branch.
Object? _if(List<D2ExprNode> args, D2ExprEvalContext ctx) {
  final cond = d2CastBoolean(args[0].eval(ctx));
  if (cond == null) return null;
  return cond ? args[1].eval(ctx) : args[2].eval(ctx);
}

/// `is(value in candidate, ...)` — true iff the first argument equals any
/// candidate (see [d2Compare] for the cross-type comparison rules).
bool _is(List<D2ExprNode> args, D2ExprEvalContext ctx) {
  final tested = args[0].eval(ctx);
  for (var i = 1; i < args.length; i++) {
    if (d2Compare(tested, args[i].eval(ctx)) == 0) return true;
  }
  return false;
}

/// `isNull(element)` — visits the argument with defaulting suspended so a
/// truly-missing value can be told apart from an explicit `0`/`false`/`''`.
bool _isNull(List<D2ExprNode> args, D2ExprEvalContext ctx) {
  return _evalAllowingNulls(args[0], ctx) == null;
}

/// `isNotNull(element)` — the inverse of [_isNull].
bool _isNotNull(List<D2ExprNode> args, D2ExprEvalContext ctx) {
  return _evalAllowingNulls(args[0], ctx) != null;
}

/// `firstNonNull(element, ...)` — returns the first argument (evaluated
/// left to right, each with defaulting suspended) that is genuinely
/// non-null; `null` if every argument is.
Object? _firstNonNull(List<D2ExprNode> args, D2ExprEvalContext ctx) {
  for (final arg in args) {
    final value = _evalAllowingNulls(arg, ctx);
    if (value != null) return value;
  }
  return null;
}

/// Evaluates [node] with missing-value defaulting temporarily suspended,
/// restoring the previous state afterwards — mirrors
/// `CommonExpressionVisitor.visitAllowingNulls`.
Object? _evalAllowingNulls(D2ExprNode node, D2ExprEvalContext ctx) {
  final saved = ctx.replaceNulls;
  ctx.replaceNulls = false;
  final value = node.eval(ctx);
  ctx.replaceNulls = saved;
  return value;
}

/// `greatest(expr, ...)` / `least(expr, ...)` — null arguments are skipped
/// once any non-null candidate has been seen; the result is `null` only if
/// every argument was `null`. This is the exact (non-obvious) DHIS2
/// null-skipping behavior, not "any null poisons the result".
double? _greatestOrLeast(
  List<D2ExprNode> args,
  D2ExprEvalContext ctx,
  bool greatest,
) {
  double? result;
  for (final arg in args) {
    final value = d2CastDouble(arg.eval(ctx));
    final better =
        value != null &&
        result != null &&
        (greatest ? value > result : value < result);
    if (result == null || better) {
      result = value;
    }
  }
  return result;
}

Object? _greatest(List<D2ExprNode> args, D2ExprEvalContext ctx) =>
    _greatestOrLeast(args, ctx, true);

Object? _least(List<D2ExprNode> args, D2ExprEvalContext ctx) =>
    _greatestOrLeast(args, ctx, false);

/// `log(expr)` (natural log) or `log(expr, base)` (change of base).
Object? _log(List<D2ExprNode> args, D2ExprEvalContext ctx) {
  final value = d2CastDouble(args[0].eval(ctx));
  if (value == null) return null;
  if (args.length > 1) {
    final base = d2CastDouble(args[1].eval(ctx));
    if (base == null) return null;
    return d2Log(value, base);
  }
  return d2Log(value);
}

/// `log10(expr)`.
Object? _log10(List<D2ExprNode> args, D2ExprEvalContext ctx) {
  final value = d2CastDouble(args[0].eval(ctx));
  if (value == null) return null;
  return d2Log10(value);
}

/// `removeZeros(expr)` — returns `null` (and disables further missing-value
/// defaulting for the rest of the expression) when the value is exactly
/// positive `0.0`; otherwise passes the value through unchanged. Can't tell
/// "genuinely missing" apart from "explicitly zero" — both collapse to
/// `null`, matching DHIS2.
Object? _removeZeros(List<D2ExprNode> args, D2ExprEvalContext ctx) {
  final value = args[0].eval(ctx);
  if (value is double && value == 0.0 && !value.isNegative) {
    ctx.replaceNulls = false;
    return null;
  }
  return value;
}

/// `orgUnit.ancestor(uid, ...)` — true iff the current org unit is a
/// *strict* descendant of any listed org unit (matches the ancestor's UID
/// followed by a path separator; the org unit is never its own ancestor).
bool _orgUnitAncestor(List<D2ExprNode> args, D2ExprEvalContext ctx) {
  final orgUnit = ctx.currentOrgUnit;
  if (orgUnit == null) return false;
  for (final arg in args) {
    final uid = d2CastString(arg.eval(ctx));
    if (orgUnit.path.contains('$uid/')) return true;
  }
  return false;
}

/// `orgUnit.dataSet(uid, ...)` — true iff the current org unit is directly
/// assigned to any listed data set.
bool _orgUnitDataSet(List<D2ExprNode> args, D2ExprEvalContext ctx) {
  final orgUnit = ctx.currentOrgUnit;
  final db = ctx.db;
  if (orgUnit == null || db == null) return false;
  for (final arg in args) {
    final uid = d2CastString(arg.eval(ctx));
    final dataSet = D2DataSetRepository(db).getByUid(uid);
    if (dataSet != null &&
        dataSet.organisationUnits.any((ou) => ou.id == orgUnit.id)) {
      return true;
    }
  }
  return false;
}

/// `orgUnit.group(uid, ...)` — true iff the current org unit is a member of
/// any listed org unit group.
bool _orgUnitGroup(List<D2ExprNode> args, D2ExprEvalContext ctx) {
  final orgUnit = ctx.currentOrgUnit;
  final db = ctx.db;
  if (orgUnit == null || db == null) return false;
  for (final arg in args) {
    final uid = d2CastString(arg.eval(ctx));
    final group = D2OrgUnitGroupRepository(db).getByUid(uid);
    if (group != null &&
        group.organisationUnits.any((ou) => ou.id == orgUnit.id)) {
      return true;
    }
  }
  return false;
}

/// `orgUnit.program(uid, ...)` — true iff the current org unit is directly
/// assigned to any listed program.
bool _orgUnitProgram(List<D2ExprNode> args, D2ExprEvalContext ctx) {
  final orgUnit = ctx.currentOrgUnit;
  final db = ctx.db;
  if (orgUnit == null || db == null) return false;
  for (final arg in args) {
    final uid = d2CastString(arg.eval(ctx));
    final program = D2ProgramRepository(db).getByUid(uid);
    if (program != null &&
        program.organisationUnits.any((ou) => ou.id == orgUnit.id)) {
      return true;
    }
  }
  return false;
}
