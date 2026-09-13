import 'dart:math' as math;

double? d2CastDouble(Object? value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is bool) return value ? 1.0 : 0.0;
  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return double.tryParse(trimmed);
  }
  return null;
}

bool? d2CastBoolean(Object? value) {
  if (value == null) return null;
  if (value is bool) return value;
  if (value is double) {
    if (value % 1 == 0) return value != 0.0;
    return null;
  }
  if (value is String) {
    final normalized = value.trim().toLowerCase();
    if (normalized == 'true') return true;
    if (normalized == 'false') return false;
    return null;
  }
  return null;
}

String d2CastString(Object? value) {
  if (value == null) return '';
  return value.toString();
}

int d2Compare(Object? a, Object? b) {
  if (a is double || b is double) {
    final da = d2CastDouble(a);
    final db = d2CastDouble(b);
    if (da == null || db == null) return da == db ? 0 : 1;
    return da.compareTo(db);
  }
  if (a is bool || b is bool) {
    final ba = d2CastBoolean(a);
    final bb = d2CastBoolean(b);
    if (ba == null || bb == null) return ba == bb ? 0 : 1;
    if (ba == bb) return 0;
    return ba ? 1 : -1;
  }
  return d2CastString(a).compareTo(d2CastString(b));
}

double d2Log(double value, [double? base]) {
  if (base == null) return math.log(value);
  return math.log(value) / math.log(base);
}

double d2Log10(double value) => math.log(value) / math.ln10;
