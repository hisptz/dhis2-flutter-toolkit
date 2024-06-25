import 'package:dhis2_flutter_toolkit/src/models/metadata/category_combo.dart';

import '../../../objectbox.g.dart';
import './base.dart';

/// This is a repository class for managing Category Combo instances.
class D2CategoryComboRepository extends BaseMetaRepository<D2CategoryCombo> {
  /// Creates a new instance of [D2CategoryComboRepository].
  ///
  /// - [db] The ObjectBox database instance.
  D2CategoryComboRepository(super.db);

  /// Retrieves a [D2CategoryCombo] instance by its [uid].
  ///
  /// Returns the [D2CategoryCombo] instance with the specified [uid], if found; otherwise, returns `null`.
  @override
  D2CategoryCombo? getByUid(String uid) {
    Query<D2CategoryCombo> query =
        box.query(D2CategoryCombo_.uid.equals(uid)).build();
    return query.findFirst();
  }

  /// Maps JSON data to a [D2CategoryCombo] instance.
  ///
  /// - [json] The JSON data to be mapped.
  ///
  /// Returns the mapped [D2CategoryCombo] instance.
  @override
  D2CategoryCombo mapper(Map<String, dynamic> json) {
    return D2CategoryCombo.fromMap(db, json);
  }
}
