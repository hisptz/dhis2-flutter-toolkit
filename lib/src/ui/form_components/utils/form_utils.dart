import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';

class FormUtils {
  static D2BaseInputFieldConfig getFieldConfigFromDataItem(
    dataItem, {
    bool mandatory = false,
    bool? allowFutureDates,
    bool? renderOptionsAsRadio,
  }) {
    // if (dataItem is D2TrackedEntityAttribute) {
    D2InputFieldType? type =
        D2InputFieldType.fromDHIS2ValueType(dataItem.valueType);
    if (type == null) {
      throw "Invalid field. ${dataItem.valueType} is either not correct or not currently supported";
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
              code: option.code, name: option.displayName ?? option.name))
          .toList();
      return D2SelectInputFieldConfig(
          options: options,
          label: label,
          type: type,
          name: dataItem.uid,
          mandatory: mandatory,
          renderOptionsAsRadio: renderOptionsAsRadio ?? false);
    }

    if (D2InputFieldType.isDateType(type)) {
      return D2DateInputFieldConfig(
          label: label,
          type: type,
          name: name,
          mandatory: mandatory,
          allowFutureDates: allowFutureDates ?? true);
    }
    if (D2InputFieldType.isDateRange(type)) {
      return D2DateRangeInputFieldConfig(
          label: label,
          type: type,
          name: name,
          mandatory: mandatory,
          allowFutureDates: allowFutureDates ?? true);
    }
    if (D2InputFieldType.isNumber(type)) {
      return D2NumberInputFieldConfig(
          label: label, type: type, name: name, mandatory: mandatory);
    }
    if (D2InputFieldType.isText(type)) {
      return D2TextInputFieldConfig(
          label: label, type: type, name: name, mandatory: mandatory);
    }

    switch (type) {
      case D2InputFieldType.boolean:
        return D2BooleanInputFieldConfig(
            label: label, type: type, name: name, mandatory: mandatory);
      case D2InputFieldType.trueOnly:
        return D2TrueOnlyInputFieldConfig(
            label: label, type: type, name: name, mandatory: mandatory);
      default:
        return D2BaseInputFieldConfig(
            label: label, type: type, name: name, mandatory: mandatory);
    }
  }
// }
}
