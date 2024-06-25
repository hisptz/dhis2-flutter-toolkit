class D2ProgramRuleResult {
  ProgramRuleHiddenFields hiddenFields;
  ProgramRuleMandatoryFields mandatoryFields;
  ProgramRuleHiddenSections hiddenSections;
  ProgramRuleAssignedValues assignedFields;
  ProgramRuleHiddenOptions hiddenOptions;
  ProgramRuleHiddenOptionGroups hiddenOptionGroups;
  ProgramRuleWarningMessages warningMessages;
  ProgramRuleErrorMessages errorMessages;

  D2ProgramRuleResult({
    required this.hiddenFields,
    required this.mandatoryFields,
    required this.hiddenSections,
    required this.assignedFields,
    required this.hiddenOptions,
    required this.hiddenOptionGroups,
    required this.warningMessages,
    required this.errorMessages,
  });
}

class ProgramRuleHiddenFields {
  late final Map<String, bool> _hiddenFields;

  ProgramRuleHiddenFields() {
    _hiddenFields = {};
  }

  bool isFieldHidden(String fieldKey) {
    return allFields[fieldKey] ?? false;
  }

  setFieldHidden(String fieldKey, bool hidden) {
    if (!isFieldHidden(fieldKey)) {
      _hiddenFields[fieldKey] = hidden;
    }
  }

  Map<String, bool> get allFields => _hiddenFields;
}

class ProgramRuleMandatoryFields {
  late final Map<String, bool> _mandatoryFields;

  ProgramRuleMandatoryFields() {
    _mandatoryFields = {};
  }

  bool isFieldMandatory(String fieldKey) {
    return allFields[fieldKey] ?? false;
  }

  setFieldMandatory(String fieldKey, bool mandatory) {
    if (!isFieldMandatory(fieldKey)) {
      _mandatoryFields[fieldKey] = mandatory;
    }
  }

  Map<String, bool> get allFields => _mandatoryFields;
}

class ProgramRuleHiddenSections {
  late final Map<String, bool> _hiddenSections;

  ProgramRuleHiddenSections() {
    _hiddenSections = {};
  }

  bool isSectionHidden(String sectionKey) {
    return allSections[sectionKey] ?? false;
  }

  setSectionHidden(String sectionKey, bool hidden) {
    if (!isSectionHidden(sectionKey)) {
      _hiddenSections[sectionKey] = hidden;
    }
  }

  Map<String, bool> get allSections => _hiddenSections;
}

class ProgramRuleAssignedValues {
  late final Map<String, dynamic> _assignedValues;

  ProgramRuleAssignedValues() {
    _assignedValues = {};
  }

  Map<String, dynamic> get allValues => _assignedValues;

  dynamic getAssignedValue(String fieldKey) {
    return allValues[fieldKey];
  }

  List<String> getAssignedFields() {
    return allValues.keys.toList();
  }

  setAssignedValue(String fieldKey, dynamic value) {
    _assignedValues[fieldKey] = value;
  }
}

class ProgramRuleHiddenOptions {
  late final Map<String, List<Map<String, bool>>> _hiddenOptions;

  ProgramRuleHiddenOptions() {
    _hiddenOptions = {};
  }

  bool isOptionHidden(String inputFieldId, String option) {
    return _hiddenOptions[inputFieldId]?.firstWhere(
            (element) => element.keys.first == option,
            orElse: () => {option: false})[option] ??
        false;
  }

  setOptionHidden(String inputFieldId, String option, bool hidden) {
    if (_hiddenOptions[inputFieldId] == null) {
      _hiddenOptions[inputFieldId] = [
        {option: hidden}
      ];
    } else {
      var existingOption = _hiddenOptions[inputFieldId]!.firstWhere(
          (element) => element.keys.first == option,
          orElse: () => {});
      if (existingOption.isEmpty || !existingOption.values.first) {
        _hiddenOptions[inputFieldId]!.add({option: hidden});
      }
    }
  }

  Map<String, List<Map<String, bool>>> get allOptions => _hiddenOptions;
}

class ProgramRuleHiddenOptionGroups {
  late final Map<String, List<Map<String, bool>>> _hiddenOptionGroups;

  ProgramRuleHiddenOptionGroups() {
    _hiddenOptionGroups = {};
  }

  bool isOptionGroupHidden(String inputFieldId, String optionGroup) {
    return _hiddenOptionGroups[inputFieldId]?.firstWhere(
            (element) => element.keys.first == optionGroup,
            orElse: () => {optionGroup: false})[optionGroup] ??
        false;
  }

  setOptionGroupHidden(String inputFieldId, String optionGroup, bool hidden) {
    if (_hiddenOptionGroups[inputFieldId] == null) {
      _hiddenOptionGroups[inputFieldId] = [
        {optionGroup: hidden}
      ];
    } else {
      var existingOptionGroup = _hiddenOptionGroups[inputFieldId]!.firstWhere(
          (element) => element.keys.first == optionGroup,
          orElse: () => {});
      if (existingOptionGroup.isEmpty || !existingOptionGroup.values.first) {
        _hiddenOptionGroups[inputFieldId]!.add({optionGroup: hidden});
      }
    }
  }

  Map<String, List<Map<String, bool>>> get allOptionGroups =>
      _hiddenOptionGroups;
}

class ProgramRuleErrorMessages {
  late final Map<String, List<ProgramRuleMessage>> _errorMessages;

  Map<String, List<ProgramRuleMessage>> get allMessages => _errorMessages;

  ProgramRuleErrorMessages() {
    _errorMessages = {};
  }

  List<ProgramRuleMessage> getError(String fieldKey) {
    return _errorMessages[fieldKey] ?? [];
  }

  void setErrorMessage(String fieldKey, ProgramRuleMessage massageObject) {
    if (getError(fieldKey).isEmpty) {
      _errorMessages[fieldKey] = [massageObject];
    } else {
      if (!_errorMessages[fieldKey]!
          .any((object) => object.message == massageObject.message)) {
        _errorMessages[fieldKey] = [...getError(fieldKey), massageObject];
      } else {
        _errorMessages[fieldKey] = _errorMessages[fieldKey]!.map((object) {
          if (object.message == massageObject.message &&
              massageObject.visibilityStatus) {
            return massageObject;
          }
          return object;
        }).toList();
      }
    }
  }
}

class ProgramRuleWarningMessages {
  late final Map<String, List<ProgramRuleMessage>> _warningMessages;

  Map<String, List<ProgramRuleMessage>> get allMessages => _warningMessages;

  ProgramRuleWarningMessages() {
    _warningMessages = {};
  }

  List<ProgramRuleMessage> getWarning(String fieldKey) {
    return _warningMessages[fieldKey] ?? [];
  }

  void setWarningMessage(String fieldKey, ProgramRuleMessage massageObject) {
    if (getWarning(fieldKey).isEmpty) {
      _warningMessages[fieldKey] = [massageObject];
    } else {
      if (!_warningMessages[fieldKey]!
          .any((object) => object.message == massageObject.message)) {
        _warningMessages[fieldKey] = [...getWarning(fieldKey), massageObject];
      } else {
        _warningMessages[fieldKey] = _warningMessages[fieldKey]!.map((object) {
          if (object.message == massageObject.message &&
              massageObject.visibilityStatus) {
            return massageObject;
          }
          return object;
        }).toList();
      }
    }
  }
}

class ProgramRuleMessage {
  final String message;
  final bool visibilityStatus;
  final bool showOnComplete;

  ProgramRuleMessage({
    required this.message,
    required this.visibilityStatus,
    required this.showOnComplete,
  });
}
