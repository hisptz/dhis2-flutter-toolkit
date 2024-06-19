import '../../../objectbox.g.dart';
import '../../models/metadata/data_set_element.dart';
import 'base.dart';

/// This class handles the repository functions for [D2DataSetElement] in the DHIS2 system.
class D2DataSetElementRepository extends BaseMetaRepository<D2DataSetElement> {
  D2DataSetElementRepository(super.db);

  /// Retrieves a [D2DataSetElement] by its UID.
  ///
  /// - [uid]: The unique identifier of the data set element.
  ///
  /// Returns the [D2DataSetElement] if found, otherwise null.
  @override
  D2DataSetElement? getByUid(String uid) {
    Query<D2DataSetElement> query =
        box.query(D2DataSetElement_.uid.equals(uid)).build();
    return query.findFirst();
  }

  /// Maps a JSON map to a [D2DataSetElement] instance.
  ///
  /// - [json]: The JSON map containing data set element information.
  ///
  /// Returns a new instance of [D2DataSetElement].
  @override
  D2DataSetElement mapper(Map<String, dynamic> json) {
    return D2DataSetElement.fromMap(db, json);
  }
}
