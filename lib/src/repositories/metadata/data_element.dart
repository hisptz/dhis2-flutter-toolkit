import '../../../objectbox.g.dart';
import '../../models/metadata/data_element.dart';
import 'base.dart';

/// This is a repository class for managing DHIS2 data elements.
class D2DataElementRepository extends BaseMetaRepository<D2DataElement> {
  /// Constructs a new [D2DataElementRepository].
  ///
  /// - [db]: The ObjectBox database.
  D2DataElementRepository(super.db);

  /// Returns a data element by its [uid].
  ///
  /// - [uid]: The UID of the data element to retrieve.
  @override
  D2DataElement? getByUid(String uid) {
    Query<D2DataElement> query =
        box.query(D2DataElement_.uid.equals(uid)).build();
    return query.findFirst();
  }

  /// Maps JSON data to a [D2DataElement] object.
  ///
  /// - [json]: The JSON data to map.
  @override
  D2DataElement mapper(Map<String, dynamic> json) {
    return D2DataElement.fromMap(db, json);
  }
}
