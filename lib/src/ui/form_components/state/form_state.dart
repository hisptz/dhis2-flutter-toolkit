import 'package:dhis2_flutter_toolkit/src/ui/form_components/state/form_data_state.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/state/form_disabled_state.dart';
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
        D2FormDisabledState,
        D2FormWarningState,
        D2FormMandatoryState,
        D2FormValueState,
        D2FormErrorState,
        D2FormDataState {
  D2FormController(
      {Map<String, dynamic>? initialValues,
      List<String>? hiddenFields,
      List<String>? hiddenSections,
      List<String>? disabledFields,
      List<String>? mandatoryFields}) {
    setValues(initialValues ?? {});
    this.hiddenFields = hiddenFields ?? [];
    this.hiddenSections = hiddenSections ?? [];
    this.mandatoryFields = mandatoryFields ?? [];
    this.disabledFields = disabledFields ?? [];
  }

  FieldState getFieldState(String key) {
    bool hidden = isFieldHidden(key);
    bool disabled = isFieldDisabled(key);
    bool mandatory = isFieldMandatory(key);
    dynamic value = getValue(key);
    String? error = getError(key);
    String? warning = getWarning(key);

    void onChange(value) {
      setValue(key, value);
    }

    return FieldState(
        onChange: onChange,
        hidden: hidden,
        value: value,
        disabled: disabled,
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
