class D2CustomAction {
  String? hiddenField;
  String? hiddenSection;
  String? disabledField;
  String?  mandatoryField;
  ErrorMessage? error;
  WarningMessage? warning;
  FieldValue? value;
  HiddenOption? hiddenOption;
  HiddenOptionGroup? hiddenOptionGroup;

  D2CustomAction({
    this.hiddenField,
    this.hiddenSection,
    this.hiddenOption,
    this.hiddenOptionGroup,
    this.disabledField,
    this.error,
    this.warning,
    this.value,
  });
}

class ErrorMessage {
  String fieldId;
  String message;

  ErrorMessage({
    required this.fieldId,
    required this.message,
  });
}

class WarningMessage {
  String fieldId;
  String message;

  WarningMessage({
    required this.fieldId,
    required this.message,
  });
}

class HiddenOption {
  String fieldId;
  String optionCode;

  HiddenOption({
    required this.fieldId,
    required this.optionCode,
  });
}

class HiddenOptionGroup {
  String fieldId;
  String optionGroupId;

  HiddenOptionGroup({
    required this.fieldId,
    required this.optionGroupId,
  });
}

class FieldValue {
  String? fieldId;
  String? value;

  FieldValue({
    this.fieldId,
    this.value,
  });
}
