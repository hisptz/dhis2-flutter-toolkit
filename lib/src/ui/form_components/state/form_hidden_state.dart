import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

mixin D2FormHiddenState on ChangeNotifier {
  List<String> hiddenFields = [];

  void toggleVisibility(String key) {
    if (hiddenFields.contains(key)) {
      hiddenFields = hiddenFields
          .whereNot((String hiddenKey) => key == hiddenKey)
          .toList();
    } else {
      hiddenFields.add(key);
    }
    notifyListeners();
  }

  bool isFieldHidden(String key) {
    return hiddenFields.contains(key);
  }
}
