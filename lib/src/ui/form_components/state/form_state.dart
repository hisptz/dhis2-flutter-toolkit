import 'package:dhis2_flutter_toolkit/src/ui/form_components/state/form_error_state.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/state/form_hidden_state.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/state/form_mandatory_state.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/state/form_value_state.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/state/form_warning_state.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/state/section_state.dart';
import 'package:flutter/material.dart';

import 'field_state.dart';

class D2FormController extends ChangeNotifier
    with
        D2FormHiddenState,
        D2FormWarningState,
        D2FormMandatoryState,
        D2FormValueState,
        D2FormErrorState {
  FieldState getFieldState(String key) {
    bool hidden = isFieldHidden(key);
    bool mandatory = isFieldMandatory(key);
    String? value = getValue(key);
    String? error = getError(key);
    String? warning = getWarning(key);

    void onChange(String? value) {
      setValue(key, value);
    }

    return FieldState(
        onChange: onChange,
        hidden: hidden,
        value: value,
        warning: warning,
        mandatory: mandatory,
        error: error);
  }

  SectionState getSectionState(String id, List<String> fieldKeys) {
    return SectionState(
        id: id,
        fieldsStates:
            fieldKeys.map((String key) => getFieldState(key)).toList());
  }
}
