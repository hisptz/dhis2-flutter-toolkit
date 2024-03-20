import '../../../models/metadata/option.dart';
import '../../../models/metadata/option_set.dart';
import '../input_field/models/base_input_field.dart';
import '../input_field/models/date_input_field.dart';
import '../input_field/models/date_range_input_field.dart';
import '../input_field/models/input_field_option.dart';
import '../input_field/models/input_field_type_enum.dart';
import '../input_field/models/select_input_field.dart';
import '../input_field/models/text_input_field.dart';

class FormUtils {
  static D2BaseInputFieldConfig getFieldConfigFromDataItem(
    dataItem, {
    bool mandatory = false,
    bool? allowFutureDates,
    bool? renderOptionsAsRadio,
  }) {
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

    if (dataItem.optionSetValue) {
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
    if (D2InputFieldType.isText(type)) {
      return D2TextInputFieldConfig(
          label: label, type: type, name: name, mandatory: mandatory);
    }

    return D2BaseInputFieldConfig(
        label: label, type: type, name: name, mandatory: mandatory);
  }
}
