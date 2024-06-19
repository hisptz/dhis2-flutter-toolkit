import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import '../input_field/models/base_input_field.dart';
import '../input_field/models/input_field_type_enum.dart';

mixin D2FormValueState on ChangeNotifier {
  List<D2BaseInputFieldConfig> formFields = [];
  final Map<String, dynamic> _formValues = {};

  Map<String, dynamic> get formValues {
    return Map.from(_formValues);
  }

  void setFormFields(List<D2BaseInputFieldConfig> fields) {
    formFields = fields;
    notifyListeners();
  }

  void setValues(Map<String, dynamic> values) {
    _formValues.addAll(values);
    notifyListeners();
  }

  sanitizeValue(String key, value) {
    //Verify the value conforms to the valid input type. If it doesn't, modify the value accordingly
    D2BaseInputFieldConfig? fieldConfig =
        formFields.firstWhereOrNull((field) => field.name == key);
    if (fieldConfig == null) {
      //This is probably an issue
      debugPrint(
          'Could not sanitize value for field $key as it was not found in the list of fields passed to the form controller');
      return value;
    }

    D2InputFieldType type = fieldConfig.type;

    //Number values sanitization
    if (D2InputFieldType.isNumber(type)) {
      if (value is String) {
        if (type == D2InputFieldType.number) {
          double? sanitizedValue = double.tryParse(value);
          if (sanitizedValue != null) {
            return sanitizedValue.toString();
          }
          return value;
        } else {
          int? sanitizedValue = double.tryParse(value)?.toInt();
          if (sanitizedValue != null) {
            return sanitizedValue.toString();
          }
          return value;
        }
      }
    }

    return value;
  }

  void setValueSilently(String key, value) {
    _formValues[key] = sanitizeValue(key, value);
  }

  void setValue(String key, value) {
    setValueSilently(key, value);
    notifyListeners();
  }

  void clearValueSilently(String key) {
    _formValues.remove(key);
  }

  void clearValue(String key) {
    clearValueSilently(key);
    notifyListeners();
  }

  getValue(String key) {
    return formValues[key];
  }
}
