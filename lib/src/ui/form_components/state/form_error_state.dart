import 'package:flutter/material.dart';

mixin D2FormErrorState on ChangeNotifier {
  final Map<String, String> _errorState = {};

  Map<String, String> get errorState {
    return Map.from(_errorState);
  }

  void setErrorSilently(String key, String error) {
    _errorState.addAll({key: error});
  }

  void setError(String key, String error) {
    setErrorSilently(key, error);
    notifyListeners();
  }

  void clearErrorSilently(String key) {
    _errorState.remove(key);
  }

  void clearError(String key) {
    clearErrorSilently(key);
    notifyListeners();
  }

  String? getError(String key) {
    return _errorState[key];
  }
}
