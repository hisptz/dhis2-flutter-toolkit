import '../../../objectbox.g.dart';

import '../../models/metadata/legend_set.dart';
import 'base.dart';

/// This is a repository class for managing [D2LegendSet] instances.
class D2LegendSetRepository extends BaseMetaRepository<D2LegendSet> {
  /// Constructs a new instance of the [D2LegendSetRepository] class.
  ///
  /// - [db] The ObjectBox database instance.
  D2LegendSetRepository(super.db);

  /// Retrieves a [D2LegendSet] instance by its unique identifier [uid].
  ///
  /// - [uid] The unique identifier of the legend set to retrieve.
  /// Returns: The [D2LegendSet] instance if found, otherwise null.
  @override
  D2LegendSet? getByUid(String uid) {
    Query<D2LegendSet> query = box.query(D2LegendSet_.uid.equals(uid)).build();
    return query.findFirst();
  }

  /// Maps a JSON object to a [D2LegendSet] instance.
  ///
  /// - [json] The JSON map containing the legend set data.
  /// Returns: A [D2LegendSet] instance constructed from the JSON data [json].
  @override
  D2LegendSet mapper(Map<String, dynamic> json) {
    return D2LegendSet.fromMap(db, json);
  }
}
