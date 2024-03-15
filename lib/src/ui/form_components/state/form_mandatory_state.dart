import 'package:flutter/material.dart';

mixin D2FormMandatoryState on ChangeNotifier {
  List<String> mandatoryFields = [];

  void init(List<String> initiallyMandatoryFields) {
    mandatoryFields.addAll(initiallyMandatoryFields);
    notifyListeners();
  }

  bool isFieldMandatory(String key) {
    return mandatoryFields.contains(key);
  }
}
