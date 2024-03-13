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
  geoJson
}

class InputField {
  String name;
  String label;
  InputFieldType type;
  bool mandatory;

  InputField(
      {required this.label,
      required this.type,
      required this.name,
      required this.mandatory});
}
