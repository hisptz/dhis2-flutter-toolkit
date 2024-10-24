import 'base_input_field.dart';

///Geometry input value. Currently only supports POINT values
class D2GeometryValue {
  double latitude;
  double longitude;

  @override
  String toString() {
    return '${latitude.toString()}, ${longitude.toString()}';
  }

  D2GeometryValue(this.latitude, this.longitude);

  D2GeometryValue.fromGeoJson(Map<String, dynamic> geoJson)
      : latitude = geoJson["coordinates"]?.first,
        longitude = geoJson["coordinates"]?.last;

  Map<String, dynamic> toGeoJson() {
    return {
      "type": "Point",
      "coordinates": [latitude, longitude]
    };
  }
}

class D2GeometryInputConfig extends D2BaseInputFieldConfig {
  bool disableMap;
  bool enableAutoLocation;
  bool isMarkerDraggable;
  D2GeometryInputConfig(
      {required super.label,
      required super.type,
      required super.name,
      required super.mandatory,
      super.clearable,
      this.enableAutoLocation = true,
      this.isMarkerDraggable = true,
      this.disableMap = false,
      super.icon,
      super.legends,
      super.svgIconAsset});
}
