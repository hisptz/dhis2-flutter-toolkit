import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/data/upload_mixin/base_aggregate_data_upload_mixin.dart';

import '../../../objectbox.g.dart';
import 'base_aggregate.dart';
import 'download_mixin/complete_registration_download_mixin.dart';
import 'query_mixin/base_aggregate_query_mixin.dart';

class D2CompleteDataSetRegistrationRepository
    extends D2BaseAggregateRepository<D2CompleteDataSetRegistration>
    with
        D2BaseAggregateQueryMixin<D2CompleteDataSetRegistration>,
        BaseAggregateDataUploadServiceMixin<D2CompleteDataSetRegistration>,
        CompleteRegistrationDownloadMixin {
  D2CompleteDataSetRegistrationRepository(super.db);

  @override
  D2CompleteDataSetRegistration? getByUid(String uid) {
    return box
        .query(D2CompleteDataSetRegistration_.uid.equals(uid))
        .build()
        .findFirst();
  }

  int? getIdByUid(String uid) {
    return getByUid(uid)?.id;
  }

  @override
  D2CompleteDataSetRegistration mapper(Map<String, dynamic> json) {
    return D2CompleteDataSetRegistration.fromMap(db, json);
  }

  bool isCompleted({
    required String dataSetUid,
    required String period,
    required String orgUnitUid,
    required String aocUid,
  }) {
    final uid = '$dataSetUid-$period-$orgUnitUid-$aocUid';
    final reg = getByUid(uid);
    return reg != null && reg.completed;
  }

  D2CompleteDataSetRegistration? getRegistration({
    required String dataSetUid,
    required String period,
    required String orgUnitUid,
    required String aocUid,
  }) {
    final uid = '$dataSetUid-$period-$orgUnitUid-$aocUid';
    return getByUid(uid);
  }

  List<D2CompleteDataSetRegistration> getByDataSet(D2DataSet dataSet) {
    return box
        .query(D2CompleteDataSetRegistration_.dataSet.equals(dataSet.id))
        .build()
        .find();
  }

  int saveRegistration(D2CompleteDataSetRegistration registration) {
    return box.put(registration);
  }

  @override
  String label = "Complete registrations";

  @override
  String uploadDataKey = "completeDataSetRegistrations";

  @override
  String uploadResource = "completeDataSetRegistrations";

  @override
  Query<D2CompleteDataSetRegistration> getUnSyncedQuery() {
    return box
        .query(D2CompleteDataSetRegistration_.synced.equals(false))
        .build();
  }
}
