import 'package:collection/collection.dart';
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/input_field/models/multi_text_input_field.dart';
import 'package:flutter/material.dart';

class D2FormUtils {
  static D2BaseInputFieldConfig getFieldConfigFromDataItem(
    dataItem, {
    bool mandatory = false,
    bool? allowFutureDates,
    bool? renderOptionsAsRadio,
    D2ObjectBox? db,
    bool? clearable,
  }) {
    D2InputFieldType? type =
        D2InputFieldType.fromDHIS2ValueType(dataItem.valueType);
    if (type == null) {
      debugPrint(
          "WARN: Invalid field. ${dataItem.valueType} is either not correct or not currently supported");
      type = D2InputFieldType.fromDHIS2ValueType("TEXT")!;
    }

    String label = dataItem.displayFormName ??
        dataItem.formName ??
        dataItem.displayName ??
        dataItem.name;

    String name = dataItem.uid;

    if (dataItem.optionSet.target != null) {
      D2OptionSet optionSet = dataItem.optionSet.target!;
      List<D2InputFieldOption> options = optionSet.options
          .map<D2InputFieldOption>((D2Option option) => D2InputFieldOption(
                code: option.code,
                name: option.displayName ?? option.name,
                sortOrder: option.sortOrder,
              ))
          .sorted((D2InputFieldOption a, D2InputFieldOption b) =>
              a.sortOrder.compareTo(b.sortOrder))
          .toList();

      if (type == D2InputFieldType.multiText) {
        return D2MultiTextInputFieldConfig(
          options: options,
          label: label,
          type: type,
          name: dataItem.uid,
          clearable: clearable ?? false,
          mandatory: mandatory,
        );
      }

      return D2SelectInputFieldConfig(
          options: options,
          label: label,
          type: type,
          name: dataItem.uid,
          clearable: clearable ?? false,
          mandatory: mandatory,
          renderOptionsAsRadio: renderOptionsAsRadio ?? false);
    }

    List<D2InputFieldLegend>? getLegends() {
      if (dataItem.legendSets.isEmpty) {
        return null;
      }
      return dataItem.legendSets.first.legends
          .map<D2InputFieldLegend>(
              (legend) => D2InputFieldLegend.fromD2Legend(legend))
          .toList();
    }

    if (D2InputFieldType.isDateType(type)) {
      return D2DateInputFieldConfig(
          label: label,
          type: type,
          name: name,
          mandatory: mandatory,
          clearable: clearable ?? false,
          allowFutureDates: allowFutureDates ?? true);
    }
    if (D2InputFieldType.isDateRange(type)) {
      return D2DateRangeInputFieldConfig(
          label: label,
          type: type,
          name: name,
          mandatory: mandatory,
          clearable: clearable ?? false,
          allowFutureDates: allowFutureDates ?? true);
    }
    if (D2InputFieldType.isNumber(type)) {
      return D2NumberInputFieldConfig(
          label: label,
          type: type,
          name: name,
          mandatory: mandatory,
          clearable: clearable ?? false,
          legends: getLegends());
    }
    if (D2InputFieldType.isText(type)) {
      return D2TextInputFieldConfig(
        label: label,
        type: type,
        name: name,
        mandatory: mandatory,
        clearable: clearable ?? false,
      );
    }

    switch (type) {
      case D2InputFieldType.boolean:
        return D2BooleanInputFieldConfig(
          label: label,
          type: type,
          name: name,
          mandatory: mandatory,
          clearable: clearable ?? false,
        );
      case D2InputFieldType.trueOnly:
        return D2TrueOnlyInputFieldConfig(
          label: label,
          type: type,
          name: name,
          mandatory: mandatory,
          clearable: clearable ?? false,
        );
      case D2InputFieldType.age:
        return D2AgeInputFieldConfig(
          label: label,
          type: type,
          name: name,
          mandatory: mandatory,
          clearable: clearable ?? false,
        );
      case D2InputFieldType.organisationUnit:
        if (db == null) {
          return D2BaseInputFieldConfig(
            label: label,
            type: type,
            name: name,
            mandatory: mandatory,
            clearable: clearable ?? false,
          );
        }
        return D2OrgUnitInputFieldConfig(
            label: label,
            type: type,
            name: name,
            mandatory: mandatory,
            service: D2LocalOrgUnitSelectorService(db));
      default:
        return D2BaseInputFieldConfig(
          label: label,
          type: type,
          name: name,
          mandatory: mandatory,
          clearable: clearable ?? false,
        );
    }
  }
// }
}
