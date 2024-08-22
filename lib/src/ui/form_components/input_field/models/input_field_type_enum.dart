import 'package:collection/collection.dart';

enum D2InputFieldType {
  text, //TODO:
  longText, //TODO:
  letter,
  phoneNumber,
  email,
  trueOnly, //TODO:
  boolean, //TODO;
  date, //TODO:
  dateRange, //TODO:
  dateTime,
  time,
  password,
  number, //TODO:
  positiveInteger,
  unitInterval,
  percentage,
  integer,
  negativeInteger,
  integerZeroOrPositive, //TODO:
  coordinate,
  organisationUnit, //TODO:
  reference,
  age, //TODO:
  url,
  file,
  image,
  multiText,
  geoJson;

  static D2InputFieldType? fromName(String? name) {
    return values.firstWhereOrNull((e) => e.name == name);
  }

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

  static bool isDateType(D2InputFieldType type) {
    return [D2InputFieldType.date, D2InputFieldType.dateTime].contains(type);
  }

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

  static bool isDateRange(D2InputFieldType type) {
    return [D2InputFieldType.dateRange].contains(type);
  }

  static bool isText(D2InputFieldType type) {
    return [
      D2InputFieldType.text,
      D2InputFieldType.longText,
      D2InputFieldType.letter,
    ].contains(type);
  }
}
