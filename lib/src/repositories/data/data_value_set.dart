import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/data/query_mixin/data_value_set_query_mixin.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/data/upload_mixin/base_aggregate_data_upload_mixin.dart';

import '../../../objectbox.g.dart';
import 'base_aggregate.dart';
import 'download_mixin/base_aggregate_data_download_service_mixin.dart';
import 'query_mixin/base_aggregate_query_mixin.dart';

class D2DataValueSetRepository extends D2BaseAggregateRepository<D2DataValueSet>
    with
        D2BaseAggregateQueryMixin<D2DataValueSet>,
        BaseAggregateDataUploadServiceMixin<D2DataValueSet>,
        D2DataValueSetQueryMixin,
        BaseAggregateDataDownloadServiceMixin {
  D2DataValueSetRepository(super.db);

  @override
  D2DataValueSet? getByUid(String uid) {
    return box.query(D2DataValueSet_.uid.equals(uid)).build().findFirst();
  }

  int? getIdByUid(String uid) {
    return getByUid(uid)?.id;
  }

  @override
  D2DataValueSet mapper(Map<String, dynamic> json) {
    return D2DataValueSet.fromMap(db, json);
  }

  D2DataValueSetRepository byDataElement(int id) {
    queryConditions = D2DataValueSet_.dataElement.equals(id);
    return this;
  }

  Future<List<D2DataValueSet>?> getByDataElement(
      D2DataValueSet dataElement) async {
    queryConditions = D2DataValueSet_.dataElement.equals(dataElement.id);
    return query.findAsync();
  }

  D2DataValueSet? getDataValue({
    required String orgUnitId,
    required String periodId,
    required String dataElementId,
  }) {
    D2OrgUnit? orgUnit = D2OrgUnitRepository(db).getByUid(orgUnitId);
    D2DataElement? dataElement =
        D2DataElementRepository(db).getByUid(dataElementId);

    if (orgUnit == null || dataElement == null) {
      return null;
    }

    return box
        .query(D2DataValueSet_.organisationUnit.equals(orgUnit.id).and(
            D2DataValueSet_.period
                .equals(periodId)
                .and(D2DataValueSet_.dataElement.equals(dataElement.id))))
        .build()
        .findFirst();
  }

  @override
  Future<List<D2DataValueSet>> saveDataValueSets(
      List<D2DataValueSet> dataValueSets) async {
    return box.putAndGetManyAsync(dataValueSets);
  }

  @override
  String label = "Data values";

  @override
  String uploadDataKey = "dataValues";

  @override
  String uploadResource = "dataValueSets";

  @override
  Query<D2DataValueSet> getUnSyncedQuery() {
    return box.query(D2DataValueSet_.synced.equals(false)).build();
  }
}
