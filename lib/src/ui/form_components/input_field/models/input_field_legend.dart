import 'dart:ui';

import '../../../../models/metadata/entry.dart';

class D2InputFieldLegend {
  double startValue;
  double endValue;
  Color color;

  D2InputFieldLegend(
      {required this.startValue, required this.endValue, required this.color});

  D2InputFieldLegend.fromD2Legend(D2Legend legend)
      : startValue = legend.startValue,
        endValue = legend.endValue,
        color = Color(int.parse(legend.color, radix: 16));
}
