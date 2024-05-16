import 'package:flutter/foundation.dart';

mixin D2FormValueState on ChangeNotifier {
  final Map<String, dynamic> _formValues = {};

  Map<String, dynamic> get formValues {
    return Map.from(_formValues);
  }

  void setValues(Map<String, dynamic> values) {
    _formValues.addAll(values);
    notifyListeners();
  }

  void setValue(String key, value) {
    _formValues[key] = value;
    notifyListeners();
  }

  void clearValue(String key) {
    _formValues.remove(key);
    notifyListeners();
  }

  getValue(String key) {
    return formValues[key];
  }
}
