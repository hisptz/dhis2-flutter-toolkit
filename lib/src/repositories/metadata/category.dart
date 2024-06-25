import '../../../objectbox.g.dart';
import '../../models/metadata/category.dart';
import './base.dart';

/// This is a repository class for managing Category instances.
class D2CategoryRepository extends BaseMetaRepository<D2Category> {
  /// Creates a new instance of [D2CategoryRepository].
  ///
  /// - [db] The ObjectBox database instance.
  D2CategoryRepository(super.db);

  /// Retrieves a [D2Category] instance by its [uid].
  ///
  /// Returns the [D2Category] instance with the specified [uid], if found; otherwise, returns `null`.
  @override
  D2Category? getByUid(String uid) {
    Query<D2Category> query = box.query(D2Category_.uid.equals(uid)).build();
    return query.findFirst();
  }

  /// Maps JSON data to a [D2Category] instance.
  ///
  /// [json] The JSON data to be mapped.
  ///
  /// Returns the mapped [D2Category] instance.
  @override
  D2Category mapper(Map<String, dynamic> json) {
    return D2Category.fromMap(db, json);
  }
}
