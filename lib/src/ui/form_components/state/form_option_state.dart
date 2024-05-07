import 'package:flutter/cupertino.dart';

mixin D2FormOptionState on ChangeNotifier {
  Map<String, List<String>> optionsToHide =
      {}; //The key of this map is the field's name/id and the value is a list of option code to hide

  void setOptionsToHide(String key, List<String> optionsToHide) {
    this.optionsToHide.addAll({key: optionsToHide});
    notifyListeners();
  }

  List<String> getFieldOptionsToHide(String key) {
    return optionsToHide[key] ?? [];
  }
}
