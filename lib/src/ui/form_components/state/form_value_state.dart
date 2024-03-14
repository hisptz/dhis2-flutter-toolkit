import 'package:flutter/foundation.dart';

mixin D2FormValueState on ChangeNotifier {
  Map<String, String?> formValues = {};

  setValue(String key, String? value) {
    formValues.addAll({key: value});
    notifyListeners();
  }

  clearValue(String key) {
    formValues.remove(key);
  }

  String? getValue(String key) {
    return formValues[key];
  }
}
