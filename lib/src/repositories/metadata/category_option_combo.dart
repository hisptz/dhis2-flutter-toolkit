import '../../../objectbox.g.dart';
import '../../models/metadata/category_option_combo.dart';
import './base.dart';

/// This is a repository class for managing Category Option Combo instances.
class D2CategoryOptionComboRepository
    extends BaseMetaRepository<D2CategoryOptionCombo> {
  /// Creates a new instance of [D2CategoryOptionComboRepository].
  ///
  /// - [db]: The ObjectBox database instance.
  D2CategoryOptionComboRepository(super.db);

  /// Retrieves a [D2CategoryOptionCombo] instance by its [uid].
  ///
  /// Returns the [D2CategoryOptionCombo] instance with the specified [uid], if found; otherwise, returns `null`.
  @override
  D2CategoryOptionCombo? getByUid(String uid) {
    Query<D2CategoryOptionCombo> query =
        box.query(D2CategoryOptionCombo_.uid.equals(uid)).build();
    return query.findFirst();
  }

  /// Maps JSON data to a [D2CategoryOptionCombo] instance.
  ///
  /// - [json]: The JSON data to be mapped.
  ///
  /// Returns the mapped [D2CategoryOptionCombo] instance.
  @override
  D2CategoryOptionCombo mapper(Map<String, dynamic> json) {
    return D2CategoryOptionCombo.fromMap(db, json);
  }
}
