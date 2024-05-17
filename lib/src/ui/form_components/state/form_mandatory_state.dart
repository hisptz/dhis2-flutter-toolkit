import 'package:flutter/material.dart';

mixin D2FormMandatoryState on ChangeNotifier {
  List<String> mandatoryFields = [];

  void init(List<String> initiallyMandatoryFields) {
    mandatoryFields.addAll(initiallyMandatoryFields);
    notifyListeners();
  }

  void addMandatoryFieldSilently(String key) {
    mandatoryFields.add(key);
  }

  void addMandatoryField(String key) {
    addMandatoryFieldSilently(key);
    notifyListeners();
  }

  void clearFromMandatoryFieldSilently(String key) {
    if (isFieldMandatory(key)) {
      mandatoryFields.remove(key);
    }
  }

  void clearFromMandatoryField(String key) {
    if (isFieldMandatory(key)) {
      clearFromMandatoryFieldSilently(key);
      notifyListeners();
    }
  }

  bool isFieldMandatory(String key) {
    return mandatoryFields.contains(key);
  }
}
