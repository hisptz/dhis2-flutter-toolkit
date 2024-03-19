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
}
