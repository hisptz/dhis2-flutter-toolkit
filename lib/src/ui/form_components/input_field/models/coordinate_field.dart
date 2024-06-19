import 'base_input_field.dart';

/// Geometry input value. Currently only supports POINT values.
class D2GeometryValue {
  double latitude;
  double longitude;

  /// Returns a string representation of the geometry value in the format 'latitude, longitude'.
  @override
  String toString() {
    return '${latitude.toString()}, ${longitude.toString()}';
  }

  /// Constructs a [D2GeometryValue] with the given latitude and longitude.
  D2GeometryValue(this.latitude, this.longitude);

  /// Constructs a [D2GeometryValue] from a GeoJSON object.
  ///
  /// - [geoJson]: A map representing the GeoJSON object with "coordinates" key.
  D2GeometryValue.fromGeoJson(Map<String, dynamic> geoJson)
      : latitude = geoJson["coordinates"]?.first,
        longitude = geoJson["coordinates"]?.last;

  /// Converts the geometry value to a GeoJSON object.
  ///
  /// Returns a map representing the GeoJSON object with "type" and "coordinates" keys.
  Map<String, dynamic> toGeoJson() {
    return {
      "type": "Point",
      "coordinates": [latitude, longitude]
    };
  }
}

/// Configuration class for geometry input fields.
class D2GeometryInputConfig extends D2BaseInputFieldConfig {
  bool disableMap;
  bool enableAutoLocation;

  /// Constructs a [D2GeometryInputConfig] with the given parameters.
  ///
  /// - [label]: The label for the input field.
  /// - [type]: The type of the input field.
  /// - [name]: The name of the input field.
  /// - [mandatory]: Indicates if the field is mandatory.
  /// - [clearable]: Indicates if the field is clearable.
  /// - [enableAutoLocation]: Enables automatic location detection if true.
  /// - [disableMap]: Disables map functionality if true.
  /// - [icon]: An optional icon for the input field.
  /// - [legends]: An optional list of legends for the input field.
  /// - [svgIconAsset]: An optional SVG icon asset for the input field.
  D2GeometryInputConfig(
      {required super.label,
      required super.type,
      required super.name,
      required super.mandatory,
      super.clearable,
      this.enableAutoLocation = true,
      this.disableMap = false,
      super.icon,
      super.legends,
      super.svgIconAsset});
}
