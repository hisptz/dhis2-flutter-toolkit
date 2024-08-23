import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'form_error_state.dart';
import 'form_hidden_state.dart';
import 'form_mandatory_state.dart';
import 'form_value_state.dart';
import 'form_warning_state.dart';

mixin D2FormDataState
    on
        ChangeNotifier,
        D2FormHiddenState,
        D2FormWarningState,
        D2FormMandatoryState,
        D2FormValueState,
        D2FormErrorState {
  ///Validity of form. Only to be set to true by the validate function
  get valid {
    return errorState.isEmpty;
  }

  String mandatoryErrorMessage = "This field is required";

  /// Runs validation in the form. Supported validations:
  /// - Mandatory fields have values
  ///
  validate() {
    validateMandatoryFields();
    notifyListeners();
  }

  void validateMandatoryFields() {
    List<String> unFilledMandatoryFields = mandatoryFields
        .where((field) {
          return !hiddenFields.contains(field);
        })
        .whereNot(fieldHasValue)
        .toList();
    //Remove errors for all filled fields
    errorState.forEach((key, value) {
      if (!unFilledMandatoryFields.contains(key) &&
          value == mandatoryErrorMessage) {
        clearError(key);
      }
    });
    if (unFilledMandatoryFields.isNotEmpty) {
      for (String key in unFilledMandatoryFields) {
        setError(
            key, mandatoryErrorMessage); //TODO: should be passed as a variable
      }
    }
  }

  bool fieldHasValue(String key) {
    var value = formValues[key];
    if (value == null) {
      return false;
    }
    if (value is String) {
      return value.isNotEmpty;
    }
    if (value is List) {
      return value.isNotEmpty;
    }
    return true;
  }

  ///Calls the validate function and returns the formValues Map if the form is valid or it throws an error if the form is invalid
  Map<String, dynamic> submit() {
    validate();
    if (valid) {
      return formValues;
    }
    throw "Form has errors. Fix the errors and try again"; //TODO: set it to be configurable
  }
}
