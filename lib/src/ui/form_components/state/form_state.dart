import 'package:dhis2_flutter_toolkit/src/ui/form_components/state/form_data_state.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/state/form_disabled_state.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/state/form_error_state.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/state/form_hidden_state.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/state/form_mandatory_state.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/state/form_option_state.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/state/form_value_state.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/state/form_warning_state.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/state/section_state.dart';
import 'package:flutter/material.dart';

import '../entry.dart';

class D2FormController extends ChangeNotifier
    with
        D2FormDisabledState,
        D2FormWarningState,
        D2FormMandatoryState,
        D2FormValueState,
        D2FormHiddenState,
        D2FormErrorState,
        D2FormDataState,
        D2FormOptionState {
  D2FormController(
      {Map<String, dynamic>? initialValues,
      this.autoAssignOptionFields = false,
      List<D2BaseInputFieldConfig>? formFields,
      List<String>? hiddenFields,
      List<String>? hiddenSections,
      List<String>? disabledFields,
      List<String>? mandatoryFields}) {
    setValues(initialValues ?? {});
    this.hiddenFields = hiddenFields ?? [];
    this.hiddenSections = hiddenSections ?? [];
    this.mandatoryFields = mandatoryFields ?? [];
    this.disabledFields = disabledFields ?? [];
    this.formFields = formFields ?? [];
    if (autoAssignOptionFields) {
      autoSetOptionValues();
    }
  }

  bool autoAssignOptionFields = false;

  void autoSetOptionValues() {
    //We need to check if a field has options
    List<D2BaseInputFieldConfig> fields =
        formFields.whereType<D2SelectInputFieldConfig>().toList();
    for (D2BaseInputFieldConfig field in fields) {
      if (field is D2SelectInputFieldConfig) {
        if (field.filteredOptions
                .where((option) =>
                    !(optionsToHide[field.name]?.contains(option.code) ??
                        false))
                .length ==
            1) {
          setValueSilently(field.name, field.filteredOptions.first.code);
        }
      }
    }
  }

  D2FieldState getFieldState(String key) {
    bool hidden = isFieldHidden(key);
    bool disabled = isFieldDisabled(key);
    bool mandatory = isFieldMandatory(key);
    dynamic value = getValue(key);
    String? error = getError(key);
    String? warning = getWarning(key);
    List<String> optionsToHide = getFieldOptionsToHide(key);
    List<String> optionsToShow = getFieldOptionsToShow(key);

    void onChange(value) {
      setValue(key, value);
    }

    return D2FieldState(
        onChange: onChange,
        optionsToHide: optionsToHide,
        optionsToShow: optionsToShow,
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
        hidden: isSectionHidden(id),
        fieldsStates:
            fieldKeys.map((String key) => getFieldState(key)).toList());
  }
}
