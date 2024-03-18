import 'package:flutter/material.dart';

mixin D2FormErrorState on ChangeNotifier {
  final Map<String, String> _errorState = {};

  Map<String, String> get errorState {
    return Map.from(_errorState);
  }

  void setError(String key, String error) {
    _errorState.addAll({key: error});
    notifyListeners();
  }

  void clearError(String key) {
    _errorState.remove(key);
    notifyListeners();
  }

  String? getError(String key) {
    return _errorState[key];
  }
}
