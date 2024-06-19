import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/models/base_input_field.dart';
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

import 'field_state.dart';

/// This class is a controller for managing the state and behavior of a dynamic form.
class D2FormController extends ChangeNotifier
    with
        D2FormHiddenState,
        D2FormDisabledState,
        D2FormWarningState,
        D2FormMandatoryState,
        D2FormValueState,
        D2FormErrorState,
        D2FormDataState,
        D2FormOptionState {
  /// Constructs a [D2FormController] with optional initial values and configuration.
  /// - [initialValues]: Initial values for the form fields.
  /// - [formFields]: List of form field configurations.
  /// - [hiddenFields]: List of initially hidden field keys.
  /// - [hiddenSections]: List of initially hidden section IDs.
  /// - [disabledFields]: List of initially disabled field keys.
  /// - [mandatoryFields]: List of mandatory field keys.
  D2FormController({
    Map<String, dynamic>? initialValues,
    List<D2BaseInputFieldConfig>? formFields,
    List<String>? hiddenFields,
    List<String>? hiddenSections,
    List<String>? disabledFields,
    List<String>? mandatoryFields,
  }) {
    setValues(initialValues ?? {});
    this.hiddenFields = hiddenFields ?? [];
    this.hiddenSections = hiddenSections ?? [];
    this.mandatoryFields = mandatoryFields ?? [];
    this.disabledFields = disabledFields ?? [];
    this.formFields = formFields ?? [];
  }

  /// Returns the state of a specific field within the form.
  /// - [key]: The identifier key of the field.
  FieldState getFieldState(String key) {
    bool hidden = isFieldHidden(key);
    bool disabled = isFieldDisabled(key);
    bool mandatory = isFieldMandatory(key);
    dynamic value = getValue(key);
    String? error = getError(key);
    String? warning = getWarning(key);
    List<String> optionsToHide = getFieldOptionsToHide(key);

    void onChange(value) {
      setValue(key, value);
    }

    return FieldState(
      onChange: onChange,
      optionsToHide: optionsToHide,
      hidden: hidden,
      value: value,
      disabled: disabled,
      warning: warning,
      mandatory: mandatory,
      error: error,
    );
  }

  /// Returns the state of a specific section within the form.
  /// - [id]: The identifier of the section.
  /// - [fieldKeys]: List of field keys belonging to the section.
  SectionState getSectionState(String id, List<String> fieldKeys) {
    return SectionState(
      id: id,
      hidden: isSectionHidden(id),
      fieldsStates: fieldKeys.map((String key) => getFieldState(key)).toList(),
    );
  }
}
