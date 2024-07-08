import 'package:collection/collection.dart';
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';

/// This is a utility class for handling form-related operations.
class D2FormUtils {
  /// Returns the appropriate [D2BaseInputFieldConfig] based on the provided data item.
  ///
  /// - [dataItem] The data item to derive the field configuration from.
  /// - [mandatory] Indicates if the field is mandatory (default is false).
  /// - [allowFutureDates] Allows future dates for date input fields.
  /// - [renderOptionsAsRadio] Renders options as radio buttons if true.
  /// - [db] An optional instance of [D2ObjectBox].
  /// - [clearable] Indicates if the field is clearable (default is false).
  ///
  /// Throws an error if the field type derived from [dataItem.valueType] is invalid or not supported.
  static D2BaseInputFieldConfig getFieldConfigFromDataItem(dataItem,
      {bool mandatory = false,
      bool? allowFutureDates,
      bool? renderOptionsAsRadio,
      D2ObjectBox? db,
      bool? clearable}) {
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

    // Handle option sets if present.
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
      return D2SelectInputFieldConfig(
          options: options,
          label: label,
          type: type,
          name: dataItem.uid,
          clearable: clearable ?? false,
          mandatory: mandatory,
          renderOptionsAsRadio: renderOptionsAsRadio ?? false);
    }

    /// Retrieves the legends associated with the data item.
    ///
    /// Returns a list of [D2InputFieldLegend] if legends are present, otherwise returns null.
    List<D2InputFieldLegend>? getLegends() {
      if (dataItem.legendSets.isEmpty) {
        return null;
      }
      return dataItem.legendSets.first.legends
          .map<D2InputFieldLegend>(
              (legend) => D2InputFieldLegend.fromD2Legend(legend))
          .toList();
    }

    // Handle different input field types.
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
