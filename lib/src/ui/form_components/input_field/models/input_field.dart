import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

enum InputFieldType {
  text,
  longText,
  letter,
  phoneNumber,
  email,
  trueOnly,
  trueOrFalse,
  date,
  dateRange,
  dateAndTime,
  time,
  password,
  number,
  positiveInteger,
  unitInterval,
  percentage,
  integer,
  negativeInteger,
  integerZeroOrPositive,
  coordinate,
  organisationUnit,
  reference,
  age,
  url,
  file,
  image,
  geoJson;

  static InputFieldType? fromName(String? name) {
    return values.firstWhereOrNull((e) => e.name == name);
  }

  static InputFieldType? fromDHIS2ValueType(String valueType) {
    String sanitizedValueType = valueType
        .toLowerCase()
        .split("_")
        .mapIndexed((int index, String word) =>
    index == 0 ? word :
    "${word[0].toUpperCase()}${word.substring(1).toLowerCase()}")
        .join("");

    return values
        .firstWhereOrNull((element) => element.name == sanitizedValueType);
  }
}

class InputFieldOption {
  String code;
  String name;

  InputFieldOption({required this.code, required this.name});

  @override
  String toString() {
    return code;
  }
}

class InputFieldLegend {}

class InputField {
  String name;
  String label;
  InputFieldType type;
  bool mandatory;
  bool clearable;
  IconData? icon;
  String? svgIconAsset;
  List<InputFieldOption>? options;
  List<InputFieldLegend>? legends;

  InputField({required this.label,
    required this.type,
    required this.name,
    required this.mandatory,
    this.icon,
    this.svgIconAsset,
    this.options,
    this.legends,
    this.clearable = false});
}
