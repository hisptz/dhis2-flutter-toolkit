import 'package:flutter/material.dart';

mixin D2FormWarningState on ChangeNotifier {
  Map<String, String> warningState = {};

  void setWarningSilently(String key, String warning) {
    warningState.addAll({key: warning});
  }

  void setWarning(String key, String warning) {
    setWarningSilently(key, warning);
    notifyListeners();
  }

  void clearWarningSilently(String key) {
    warningState.remove(key);
  }

  void clearWarning(String key) {
    clearWarningSilently(key);
    notifyListeners();
  }

  String? getWarning(String key) {
    return warningState[key];
  }
}
