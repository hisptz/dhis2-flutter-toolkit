import '../../../objectbox.g.dart';

import '../../models/metadata/option.dart';
import 'base.dart';

/// This is a repository class for handling [D2Option] objects, extending [BaseMetaRepository].
class D2OptionRepository extends BaseMetaRepository<D2Option> {
  /// Constructs a [D2OptionRepository].
  ///
  /// Parameters:
  /// - [db]: Instance of [D2ObjectBox].
  D2OptionRepository(super.db);

  /// Retrieves a [D2Option] by its UID [uid].
  ///
  /// Parameters:
  /// - [uid]: Unique identifier of the option.
  ///
  /// Returns a [D2Option] object if found, otherwise null.
  @override
  D2Option? getByUid(String uid) {
    Query<D2Option> query = box.query(D2Option_.uid.equals(uid)).build();
    return query.findFirst();
  }

  /// Maps a JSON object to a [D2Option] object.
  ///
  /// Parameters:
  /// - [json]: JSON map containing the option data.
  ///
  /// Returns a [D2Option] object.
  @override
  D2Option mapper(Map<String, dynamic> json) {
    return D2Option.fromMap(db, json);
  }
}
