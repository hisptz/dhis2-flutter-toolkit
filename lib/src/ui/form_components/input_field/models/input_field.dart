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
  positiveOrZeroInteger,
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

  InputField(
      {required this.label,
      required this.type,
      required this.name,
      required this.mandatory,
      this.icon,
      this.svgIconAsset,
      this.options,
      this.legends,
      this.clearable = false});
}
