import '../../../objectbox.g.dart';
import '../../models/metadata/data_set.dart';
import './base.dart';
import 'download_mixins/base_meta_download_mixin.dart';
import 'download_mixins/data_set_download_mixin.dart';

/// This class handles the repository functions for [D2DataSet] in DHIS2.
class D2DataSetRepository extends BaseMetaRepository<D2DataSet>
    with
        BaseMetaDownloadServiceMixin<D2DataSet>,
        D2DataSetDownloadServiceMixin {
  D2DataSetRepository(super.db);

  /// Retrieves a [D2DataSet] by its UID.
  ///
  /// - [uid]: The unique identifier of the data set.
  ///
  /// Returns the [D2DataSet] if found, otherwise null.
  @override
  D2DataSet? getByUid(String uid) {
    Query<D2DataSet> query = box.query(D2DataSet_.uid.equals(uid)).build();
    return query.findFirst();
  }

  /// Maps a JSON map to a [D2DataSet] instance.
  ///
  /// - [json]: The JSON map containing data set information.
  ///
  /// Returns a new instance of [D2DataSet].
  @override
  D2DataSet mapper(Map<String, dynamic> json) {
    return D2DataSet.fromMap(db, json);
  }
}
