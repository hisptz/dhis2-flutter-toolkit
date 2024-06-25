import '../../../objectbox.g.dart';

import '../../models/metadata/program.dart';
import 'download_mixins/base_meta_download_mixin.dart';
import 'download_mixins/program_download_mixin.dart';

import 'base.dart';

/// This is a repository class for managing [D2Program] entities with various utility methods.
class D2ProgramRepository extends BaseMetaRepository<D2Program>
    with
        BaseMetaDownloadServiceMixin<D2Program>,
        D2ProgramDownloadServiceMixin {
  /// Constructs a [D2ProgramRepository].
  ///
  /// - [db] The database instance.
  D2ProgramRepository(super.db);

  /// Retrieves a [D2Program] by its UID [uid].
  ///
  /// - [uid] The unique identifier of the program.
  ///
  /// Returns the [D2Program] with the specified UID, or `null` if not found.
  @override
  D2Program? getByUid(String uid) {
    Query<D2Program> query = box.query(D2Program_.uid.equals(uid)).build();
    return query.findFirst();
  }

  /// Maps a JSON object [json] to a [D2Program] instance.
  ///
  /// - [json] The JSON object containing program data.
  ///
  /// Returns the [D2Program] instance created from the JSON data.
  @override
  D2Program mapper(Map<String, dynamic> json) {
    return D2Program.fromMap(db, json);
  }

  /// Creates a query to find [D2Program] by an identifiable token [keyword].
  ///
  /// - [keyword] The keyword to search for in UID, name, or short name.
  ///
  /// Returns the [D2ProgramRepository] instance with the query conditions applied.
  D2ProgramRepository byIdentifiableToken(String keyword) {
    queryConditions = D2Program_.uid
        .equals(keyword)
        .or(D2Program_.name.contains(keyword, caseSensitive: false))
        .or(D2Program_.shortName.contains(keyword, caseSensitive: false));
    return this;
  }
}
