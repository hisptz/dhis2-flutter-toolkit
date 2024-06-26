import 'package:collection/collection.dart';

/// Enumeration representing different types of input fields.
enum D2InputFieldType {
  /// Single-line text input.
  text, //TODO:

  /// Multi-line text input.
  longText, //TODO:

  /// Single letter input.
  letter,

  /// Phone number input.
  phoneNumber,

  /// Email address input.
  email,

  /// True/false toggle input.
  trueOnly, //TODO:

  /// Boolean input.
  boolean, //TODO;

  /// Date input.
  date, //TODO:

  /// Date range input.
  dateRange, //TODO:

  /// Date and time input.
  dateTime,

  /// Time input.
  time,

  /// Password input.
  password,

  /// Number input.
  number, //TODO:

  /// Positive integer input.
  positiveInteger,

  /// Unit interval input.
  unitInterval,

  /// Percentage input.
  percentage,

  /// Integer input.
  integer,

  /// Negative integer input.
  negativeInteger,

  /// Non-negative integer input.
  integerZeroOrPositive, //TODO:

  /// Coordinate input.
  coordinate,

  /// Organisation unit input.
  organisationUnit, //TODO:

  /// Reference input.
  reference,

  /// Age input.
  age, //TODO:

  /// URL input.
  url,

  /// File input.
  file,

  /// Image input.
  image,

  /// GeoJSON input.
  geoJson;

  /// Returns the corresponding [D2InputFieldType] for the given [name].
  ///
  /// If no match is found, returns `null`.
  static D2InputFieldType? fromName(String? name) {
    return values.firstWhereOrNull((e) => e.name == name);
  }

  /// Returns the corresponding [D2InputFieldType] for the given DHIS2 [valueType].
  ///
  /// Converts the [valueType] to a camelCase format and matches it with the enum values.
  /// If no match is found, returns `null`.
  static D2InputFieldType? fromDHIS2ValueType(String valueType) {
    String sanitizedValueType = valueType
        .toLowerCase()
        .split("_")
        .mapIndexed((int index, String word) => index == 0
            ? word
            : "${word[0].toUpperCase()}${word.substring(1).toLowerCase()}")
        .join("");

    return values
        .firstWhereOrNull((element) => element.name == sanitizedValueType);
  }

  /// Checks if the given [type] is a date type.
  ///
  /// Returns [bool], Whether the type is [date] or [dateTime].
  static bool isDateType(D2InputFieldType type) {
    return [D2InputFieldType.date, D2InputFieldType.dateTime].contains(type);
  }

  /// Checks if the given [type] is a number type.
  ///
  /// Returns `true` if the type is [number], [positiveInteger], [negativeInteger],
  /// [integer], [integerZeroOrPositive], [unitInterval], or [percentage], otherwise `false`.
  static bool isNumber(D2InputFieldType type) {
    return [
      D2InputFieldType.number,
      D2InputFieldType.positiveInteger,
      D2InputFieldType.negativeInteger,
      D2InputFieldType.integer,
      D2InputFieldType.integerZeroOrPositive,
      D2InputFieldType.unitInterval,
      D2InputFieldType.percentage
    ].contains(type);
  }

  /// Checks if the given [type] is a date range type.
  ///
  /// Returns [bool], Whether the type is [dateRange].
  static bool isDateRange(D2InputFieldType type) {
    return [D2InputFieldType.dateRange].contains(type);
  }

  /// Checks if the given [type] is a text type.
  ///
  /// Returns [bool], Whether the type is [text], [longText], or [letter].
  static bool isText(D2InputFieldType type) {
    return [
      D2InputFieldType.text,
      D2InputFieldType.longText,
      D2InputFieldType.letter,
    ].contains(type);
  }
}
