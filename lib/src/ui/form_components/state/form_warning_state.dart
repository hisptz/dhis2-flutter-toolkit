import 'package:flutter/material.dart';

mixin D2FormWarningState on ChangeNotifier {
  Map<String, String> warningState = {};

  void setWarning(String key, String warning) {
    warningState.addAll({key: warning});
    notifyListeners();
  }

  void clearWarning(String key) {
    warningState.remove(key);
    notifyListeners();
  }

  String? getWarning(String key) {
    return warningState[key];
  }
}
