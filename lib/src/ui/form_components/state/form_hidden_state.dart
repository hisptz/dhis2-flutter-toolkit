import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

mixin D2FormHiddenState on ChangeNotifier {
  List<String> hiddenFields = [];
  List<String> hiddenSections = [];

  void toggleFieldVisibility(String key) {
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
  
  void toggleSectionVisibility(String key) {
    if (hiddenSections.contains(key)) {
      hiddenSections = hiddenSections
          .whereNot((String hiddenKey) => key == hiddenKey)
          .toList();
    } else {
      hiddenSections.add(key);
    }
    notifyListeners();
  }

  bool isSectionHidden(String key) {
    return hiddenSections.contains(key);
  }
}
