import '../../../objectbox.g.dart';

import '../../models/metadata/legend.dart';
import 'base.dart';

/// This is a repository class for handling operations related to [D2Legend] entities.
class D2LegendRepository extends BaseMetaRepository<D2Legend> {
  /// Constructs a new instance of the [D2LegendRepository] class.
  ///
  /// - [db] The ObjectBox database instance.
  D2LegendRepository(super.db);

  /// Retrieves a [D2Legend] entity by its UID.
  ///
  /// - [uid] The unique identifier of the legend.
  ///
  /// Returns the [D2Legend] entity if found, otherwise null.
  @override
  D2Legend? getByUid(String uid) {
    Query<D2Legend> query = box.query(D2Legend_.uid.equals(uid)).build();
    return query.findFirst();
  }

  /// Maps a JSON object to a [D2Legend] entity.
  ///
  /// - [json] The JSON map containing the legend data.
  ///
  /// Returns the mapped [D2Legend] entity.
  @override
  D2Legend mapper(Map<String, dynamic> json) {
    return D2Legend.fromMap(db, json);
  }
}
