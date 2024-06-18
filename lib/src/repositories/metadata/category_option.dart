import '../../../objectbox.g.dart';
import '../../models/metadata/category_option.dart';
import './base.dart';

/// This is a repository class for managing Category Option instances.
class D2CategoryOptionRepository extends BaseMetaRepository<D2CategoryOption> {
  /// Creates a new instance of [D2CategoryOptionRepository].
  ///
  /// - [db]: The ObjectBox database instance.
  D2CategoryOptionRepository(super.db);

  /// Retrieves a [D2CategoryOption] instance by its [uid].
  ///
  /// Returns the [D2CategoryOption] instance with the specified [uid], if found; otherwise, returns `null`.
  @override
  D2CategoryOption? getByUid(String uid) {
    Query<D2CategoryOption> query =
        box.query(D2CategoryOption_.uid.equals(uid)).build();
    return query.findFirst();
  }

  /// Maps JSON data to a [D2CategoryOption] instance.
  ///
  /// - [json]: The JSON data to be mapped.
  ///
  /// Returns the mapped [D2CategoryOption] instance.
  @override
  D2CategoryOption mapper(Map<String, dynamic> json) {
    return D2CategoryOption.fromMap(db, json);
  }
}
