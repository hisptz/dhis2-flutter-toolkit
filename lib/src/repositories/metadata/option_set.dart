import '../../../objectbox.g.dart';

import '../../models/metadata/option_set.dart';
import 'base.dart';

/// This is a repository class for managing [D2OptionSet] entities.
class D2OptionSetRepository extends BaseMetaRepository<D2OptionSet> {
  /// Constructs a [D2OptionSetRepository].
  ///
  /// Parameters:
  /// - [db]: The [D2ObjectBox] instance.
  D2OptionSetRepository(super.db);

  /// Retrieves a [D2OptionSet] by its [uid].
  ///
  /// Parameters:
  /// - [uid]: The unique identifier of the option set.
  ///
  /// Returns the [D2OptionSet] with the specified UID, or `null` if not found.
  @override
  D2OptionSet? getByUid(String uid) {
    Query<D2OptionSet> query = box.query(D2OptionSet_.uid.equals(uid)).build();
    return query.findFirst();
  }

  /// Maps a JSON object to a [D2OptionSet] instance.
  ///
  /// Parameters:
  /// - [json]: The JSON map containing option set data.
  ///
  /// Returns a [D2OptionSet] instance created from the provided JSON data.

  @override
  D2OptionSet mapper(Map<String, dynamic> json) {
    return D2OptionSet.fromMap(db, json);
  }
}
