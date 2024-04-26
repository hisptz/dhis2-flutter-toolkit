import '../../../../objectbox.g.dart';
import '../../../models/data/entry.dart';
import '../../../models/metadata/entry.dart';
import 'base_aggregate_query_mixin.dart';

mixin D2DataValueSetQueryMixin on D2BaseAggregateQueryMixin<D2DataValueSet> {
  setAttributeOptionCombo(D2CategoryOptionCombo attributeCombo) {
    updateQueryCondition(
        D2DataValueSet_.attributeOptionCombo.equals(attributeCombo.id));
    return this;
  }

  setOrgUnit(D2OrgUnit orgUnit) {
    updateQueryCondition(D2DataValueSet_.organisationUnit.equals(orgUnit.id));
    return this;
  }

  setPeriod(String period) {
    updateQueryCondition(D2DataValueSet_.period.equals(period));
    return this;
  }

  setDataElement(D2DataElement dataElement) {
    updateQueryCondition(D2DataValueSet_.dataElement.equals(dataElement.id));
    return this;
  }

  setCategoryOptionCombo(D2CategoryOptionCombo categoryOptionCombo) {
    updateQueryCondition(
        D2DataValueSet_.categoryOptionCombo.equals(categoryOptionCombo.id));
    return this;
  }

  setDataSet(D2DataSet dataSet) {
    List<D2CategoryOptionCombo> options =
        dataSet.categoryCombo.target!.categoryOptionCombos;

    if (options.length > 1) {
      throw "You cannot set a data set with more than one attribute option. Call setAttributeOptionCombo instead";
    }
    setAttributeOptionCombo(options.first);
    return this;
  }
}
