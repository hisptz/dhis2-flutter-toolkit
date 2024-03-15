import 'package:flutter/foundation.dart';

mixin D2FormValueState on ChangeNotifier {
  final Map<String, String?> _formValues = {};

  get formValues {
    return Map.from(_formValues);
  }

  setValue(String key, String? value) {
    _formValues[key] = value;
    notifyListeners();
  }

  clearValue(String key) {
    _formValues.remove(key);
    notifyListeners();
  }

  String? getValue(String key) {
    return formValues[key];
  }
}
