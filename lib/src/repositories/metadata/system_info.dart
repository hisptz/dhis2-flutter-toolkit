import '../../models/metadata/system_info.dart';
import 'base.dart';
import 'download_mixins/base_single_meta_download_mixin.dart';
import 'download_mixins/system_info_download_mixin.dart';
import '../../../objectbox.g.dart';

/// This is a repository class for managing the DHIS2 system information.
class D2SystemInfoRepository extends BaseMetaRepository<D2SystemInfo>
    with
        BaseSingleMetaDownloadServiceMixin<D2SystemInfo>,
        D2SystemInfoDownloadServiceMixin {
  /// Constructs a [D2SystemInfoRepository] instance with the specified database.
  ///
  /// - [db] is the instance of [D2ObjectBox].
  D2SystemInfoRepository(super.db);

  /// Retrieves the ID of a system information record by its UID.
  ///
  /// - [uid] is the unique identifier for the system information.
  ///
  /// Returns the ID of the system information record, or null if not found.
  @override
  int? getIdByUid(String uid) {
    return getByUid(uid)?.id;
  }

  /// Retrieves the first system information record from the database.
  ///
  /// Returns the first [D2SystemInfo] record found, or null if not found.
  D2SystemInfo? get() {
    Query<D2SystemInfo> query = box.query().build();
    return query.findFirst();
  }

  /// Retrieves a system information record by its UID.
  ///
  /// - [uid] is the unique identifier for the system information.
  ///
  /// Returns the [D2SystemInfo] record found, or null if not found.
  @override
  D2SystemInfo? getByUid(String uid) {
    Query<D2SystemInfo> query =
        box.query(D2SystemInfo_.systemId.equals(uid)).build();
    return query.findFirst();
  }

  /// Maps JSON data to a [D2SystemInfo] object.
  ///
  /// - [json] is the JSON map containing the system information.
  ///
  /// Returns the mapped [D2SystemInfo] object.
  @override
  D2SystemInfo mapper(Map<String, dynamic> json) {
    return D2SystemInfo.fromMap(db, json);
  }
}
