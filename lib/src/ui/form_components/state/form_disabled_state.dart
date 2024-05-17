import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

mixin D2FormDisabledState on ChangeNotifier {
  List<String> disabledFields = [];

  void toggleFieldDisable(String key) {
    if (disabledFields.contains(key)) {
      disabledFields = disabledFields
          .whereNot((String disabledKey) => key == disabledKey)
          .toList();
    } else {
      disabledFields.add(key);
    }
    notifyListeners();
  }

  void clearDisabledField(String key) {
    disabledFields.remove(key);
    notifyListeners();
  }

  void disableFields(List<String> keys) {
    disabledFields.addAll(keys);
    disabledFields = disabledFields.toSet().toList();
  }

  bool isFieldDisabled(String key) {
    return disabledFields.contains(key);
  }
}
