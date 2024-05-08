import 'dart:ui';

import '../../../../models/metadata/entry.dart';

class D2InputFieldLegend {
  double startValue;
  double endValue;
  Color color;

  bool valueInRange(double value) {
    return value >= startValue && value < endValue;
  }

  static int stringToHexInt(String value) {
    return int.parse(value.substring(1, 7), radix: 16) + 0xFF000000;
  }

  D2InputFieldLegend(
      {required this.startValue, required this.endValue, required this.color});

  D2InputFieldLegend.fromD2Legend(D2Legend legend)
      : startValue = legend.startValue,
        endValue = legend.endValue,
        color = Color(stringToHexInt(legend.color));
}
