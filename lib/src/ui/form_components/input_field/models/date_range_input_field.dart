import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';

class D2DateRangeInputFieldValue {
  DateTime start;
  DateTime end;

  D2DateRangeInputFieldValue({required this.start, required this.end});
}

class D2DateRangeInputFieldConfig extends D2DateInputFieldConfig {
  D2DateRangeInputFieldConfig(
      {required super.label,
      required super.type,
      required super.name,
      required super.mandatory,
      super.firstDate,
      super.lastDate,
      super.allowFutureDates = false,
      super.clearable,
      super.icon,
      super.legends,
      super.svgIconAsset});
}
