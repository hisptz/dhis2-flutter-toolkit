import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';

class D2CoordinateValue {
  double latitude;
  double longitude;

  @override
  String toString() {
    return '${latitude.toString()}, ${longitude.toString()}';
  }

  D2CoordinateValue(this.latitude, this.longitude);
}

class D2CoordinateInputConfig extends D2BaseInputFieldConfig {
  bool disableMap;

  D2CoordinateInputConfig(
      {required super.label,
      required super.type,
      required super.name,
      required super.mandatory,
      super.clearable,
      this.disableMap = false,
      super.icon,
      super.legends,
      super.svgIconAsset});
}
