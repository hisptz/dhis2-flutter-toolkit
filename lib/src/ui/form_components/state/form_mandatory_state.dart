import 'package:flutter/material.dart';

mixin D2FormMandatoryState on ChangeNotifier {
  List<String> mandatoryFields = [];

  void init(List<String> initiallyMandatoryFields) {
    mandatoryFields.addAll(initiallyMandatoryFields);
    notifyListeners();
  }

  void addMandatoryField(String key) {
    mandatoryFields.add(key);
    notifyListeners();
  }

  void clearFromMandatoryField(String key) {
    if (isFieldMandatory(key)) {
      mandatoryFields.remove(key);
      notifyListeners();
    }
  }

  bool isFieldMandatory(String key) {
    return mandatoryFields.contains(key);
  }
}
