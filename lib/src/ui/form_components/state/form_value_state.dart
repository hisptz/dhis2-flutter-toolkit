import 'package:flutter/foundation.dart';

mixin D2FormValueState on ChangeNotifier {
  final Map<String, dynamic> _formValues = {};

  get formValues {
    return Map.from(_formValues);
  }

  setValue(String key, value) {
    _formValues[key] = value;
    notifyListeners();
  }

  clearValue(String key) {
    _formValues.remove(key);
    notifyListeners();
  }

  getValue(String key) {
    return formValues[key];
  }
}
