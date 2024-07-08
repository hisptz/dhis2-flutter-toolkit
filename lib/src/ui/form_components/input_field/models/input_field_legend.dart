import 'dart:ui';

import '../../../../models/metadata/entry.dart';

/// This class represents a legend for input fields, defining a range of values and a corresponding color.
class D2InputFieldLegend {
  /// The start value of the range.
  double startValue;

  /// The end value of the range.
  double endValue;

  /// The color associated with the range.
  Color color;

  /// Checks if a given value is within the range defined by this legend.
  ///
  /// - [value] The value to check.
  /// Returns [bool] Whether the value is within the range.
  bool valueInRange(double value) {
    return value >= startValue && value < endValue;
  }

  /// Converts a hexadecimal color string to an integer value.
  ///
  /// - [value] The hexadecimal color string.
  /// Returns: The integer representation of the color.
  static int stringToHexInt(String value) {
    return int.parse(value.substring(1, 7), radix: 16) + 0xFF000000;
  }

  /// Constructs a legend with the specified range and color.
  ///
  /// - [startValue] The start value of the range.
  /// - [endValue] The end value of the range.
  /// - [color] The color associated with the range.
  D2InputFieldLegend(
      {required this.startValue, required this.endValue, required this.color});

  /// Constructs a legend from a D2Legend object.
  ///
  /// - [legend] The D2Legend object.
  D2InputFieldLegend.fromD2Legend(D2Legend legend)
      : startValue = legend.startValue,
        endValue = legend.endValue,
        color = Color(stringToHexInt(legend.color));
}
