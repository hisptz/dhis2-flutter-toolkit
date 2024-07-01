import 'package:flutter/cupertino.dart';

mixin D2FormOptionState on ChangeNotifier {
  Map<String, List<String>> optionsToHide =
      {}; //The key of this map is the field's name/id and the value is a list of option code to hide

  void setOptionsToHideSilently(String key, List<String> options) {
    optionsToHide.addAll({
      key: [...(optionsToHide[key] ?? []), ...options]
    });
  }

  void setOptionsToHide(String key, List<String> optionsToHide) {
    setOptionsToHideSilently(key, optionsToHide);
    notifyListeners();
  }

  void removeOptionsToHideSilently(String key, List<String> options) {
    optionsToHide[key] = (optionsToHide[key] ?? [])
        .where((hiddenOption) => !options.contains(hiddenOption))
        .toList();
  }

  void removeOptionsToHide(String key, List<String> options) {
    removeOptionsToHideSilently(key, options);
    notifyListeners();
  }

  void clearHiddenOptionsSilently(String key) {
    if (getFieldOptionsToHide(key).isNotEmpty) {
      optionsToHide.remove(key);
    }
  }

  void clearHiddenOptions(String key) {
    clearHiddenOptionsSilently(key);
    if (getFieldOptionsToHide(key).isNotEmpty) {
      notifyListeners();
    }
  }

  List<String> getFieldOptionsToHide(String key) {
    return optionsToHide[key] ?? [];
  }
}
