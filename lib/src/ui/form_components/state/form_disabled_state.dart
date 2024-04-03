import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

mixin D2FormDisabledState on ChangeNotifier {
  List<String> disabledFields = [];

  void toggleFieldVisibility(String key) {
    if (disabledFields.contains(key)) {
      disabledFields = disabledFields
          .whereNot((String disabledKey) => key == disabledKey)
          .toList();
    } else {
      disabledFields.add(key);
    }
    notifyListeners();
  }

  bool isFieldDisabled(String key) {
    return disabledFields.contains(key);
  }
}
