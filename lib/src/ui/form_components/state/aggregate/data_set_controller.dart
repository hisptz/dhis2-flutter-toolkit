import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:flutter/foundation.dart';

/// This class handles the state and operations for a DHIS2 dataset form.
class D2DataSetStateFormController extends D2FormController {
  D2ObjectBox db;
  D2DataSet dataSet;
  String period;
  late D2OrgUnit orgUnit;
  late D2CategoryOptionCombo attributeOptionCombo;

  /// Constructs a new instance of [D2DataSetStateFormController].
  ///
  /// - [dataSet] The data set being handled.
  /// - [db] The database instance.
  /// - [period] The period for which the data set is being managed.
  /// - [orgUnitId] The ID of the organisation unit.
  /// - [attributeOptionCombo] An optional attribute option combo.
  /// - [hiddenFields] Fields to be hidden in the form.
  /// - [disabledFields] Fields to be disabled in the form.
  /// - [initialValues] Initial values for the form fields.
  /// - [hiddenSections] Sections to be hidden in the form.
  /// - [formFields] Fields included in the form.
  /// - [mandatoryFields] Fields that are mandatory in the form.
  D2DataSetStateFormController(
      {required this.dataSet,
      required this.db,
      required this.period,
      required String orgUnitId,
      D2CategoryOptionCombo? attributeOptionCombo,
      super.hiddenFields,
      super.disabledFields,
      super.initialValues,
      super.hiddenSections,
      super.formFields,
      super.mandatoryFields}) {
    /// A data set with default attribute option combo will only have one option. If it has more than one option it should be passed as an attributeOptionCombo in the controller's constructor
    if (dataSet.categoryCombo.target!.categoryOptionCombos.length > 1) {
      if (attributeOptionCombo == null) {
        throw "You need to specify the attribute option combo";
      }
      this.attributeOptionCombo = attributeOptionCombo;
    } else {
      this.attributeOptionCombo =
          dataSet.categoryCombo.target!.categoryOptionCombos.first;
    }
    D2OrgUnit? orgUnit = D2OrgUnitRepository(db).getByUid(orgUnitId);
    if (orgUnit == null) {
      throw "Could not find org unit with id $orgUnitId";
    }
    this.orgUnit = orgUnit;
    mandatoryFields.addAll(getMandatoryFieldsFromDataSet());
  }

  /// Retrieves the mandatory fields from the data set.
  getMandatoryFieldsFromDataSet() {
    return dataSet.compulsoryDataElementOperands.map((item) => item.uid);
  }

  /// Saves the form data.
  ///
  /// Returns a [Future] containing a list of saved data value sets.
  Future<List<dynamic>> save() async {
    Map<String, dynamic> validatedFormValues = submit();
    List<D2DataValueSet> values = [];
    for (MapEntry<String, dynamic> value in validatedFormValues.entries) {
      List<String> keyString = value.key.split('.');
      if (keyString.length < 2) {
        /// Not a valid data entry. Probably a custom field. Ignoring
        continue;
      }
      String dataElementId = keyString.first;
      String categoryOptionComboId = keyString.last;
      D2DataElement? dataElement =
          D2DataElementRepository(db).getByUid(dataElementId);
      D2CategoryOptionCombo? categoryOptionCombo =
          D2CategoryOptionComboRepository(db).getByUid(categoryOptionComboId);

      if (dataElement == null || categoryOptionCombo == null) {
        /// Invalid entries. Ignoring
        if (kDebugMode) {
          print(
              'Invalid data element $dataElementId or option combo $categoryOptionComboId. Ignoring data entry');
          continue;
        }
      }

      D2DataValueSet d2dataValueSet = D2DataValueSet.fromForm(
          db: db,
          orgUnit: orgUnit,
          attributeOptionCombo: attributeOptionCombo,
          period: period,
          value: value.value,
          dataElement: dataElement!,
          categoryOptionCombo: categoryOptionCombo!);
      values.add(d2dataValueSet);
    }
    return await D2DataValueSetRepository(db).saveDataValueSets(values);
  }
}
