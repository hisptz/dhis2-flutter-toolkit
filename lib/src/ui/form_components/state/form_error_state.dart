import 'package:flutter/material.dart';

mixin D2FormErrorState on ChangeNotifier {
  Map<String, String> errorState = {};

  void setError(String key, String error) {
    errorState.addAll({key: error});
    notifyListeners();
  }

  void clearError(String key) {
    errorState.remove(key);
    notifyListeners();
  }

  String? getError(String key) {
    return errorState[key];
  }
}
