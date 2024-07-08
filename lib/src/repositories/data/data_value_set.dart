import 'package:dhis2_flutter_toolkit/src/repositories/data/query_mixin/data_value_set_query_mixin.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/data/upload_mixin/base_aggregate_data_upload_mixin.dart';

import '../../../objectbox.g.dart';
import '../../models/data/data_value_set.dart';
import 'base_aggregate.dart';
import 'download_mixin/base_aggregate_data_download_service_mixin.dart';
import 'query_mixin/base_aggregate_query_mixin.dart';

/// This class manages operations related to data value sets in the DHIS2 system.
class D2DataValueSetRepository extends D2BaseAggregateRepository<D2DataValueSet>
    with
        D2BaseAggregateQueryMixin<D2DataValueSet>,
        BaseAggregateDataUploadServiceMixin<D2DataValueSet>,
        D2DataValueSetQueryMixin,
        BaseAggregateDataDownloadServiceMixin {
  D2DataValueSetRepository(super.db);

  /// Retrieves a data value set by its unique identifier [uid].
  ///
  /// Returns a [D2DataValueSet] object if found, otherwise returns null.
  @override
  D2DataValueSet? getByUid(String uid) {
    return box.query(D2DataValueSet_.uid.equals(uid)).build().findFirst();
  }

  /// Retrieves the ID of a data value set by its unique identifier [uid].
  ///
  /// Returns an [int] representing the ID if found, otherwise returns null.
  int? getIdByUid(String uid) {
    return getByUid(uid)?.id;
  }

  /// Maps a JSON map to a [D2DataValueSet] object.
  ///
  /// Returns the mapped [D2DataValueSet] object.
  @override
  D2DataValueSet mapper(Map<String, dynamic> json) {
    return D2DataValueSet.fromMap(db, json);
  }

  /// Restricts the query to retrieve data value sets associated with a specific data element [id].
  ///
  /// Returns the updated [D2DataValueSetRepository] instance.
  D2DataValueSetRepository byDataElement(int id) {
    queryConditions = D2DataValueSet_.dataElement.equals(id);
    return this;
  }

  /// Retrieves data value sets associated with a specific data element.
  ///
  /// Returns a [Future] list of [D2DataValueSet] objects.
  Future<List<D2DataValueSet>?> getByDataElement(
      D2DataValueSet dataElement) async {
    queryConditions = D2DataValueSet_.dataElement.equals(dataElement.id);
    return query.findAsync();
  }

  /// Saves multiple data value sets asynchronously.
  ///
  /// Returns a [Future] list of saved [D2DataValueSet] objects.
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

  /// Retrieves a query for unsynchronized data value sets.
  ///
  /// Returns a [Query] object for unsynchronized data value sets.
  @override
  Query<D2DataValueSet> getUnSyncedQuery() {
    return box.query(D2DataValueSet_.synced.equals(false)).build();
  }
}
