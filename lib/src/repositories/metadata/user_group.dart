import '../../../objectbox.g.dart';

import '../../models/metadata/user_group.dart';
import 'base.dart';

/// This is a repository class for managing [D2UserGroup] instances in the database.
class D2UserGroupRepository extends BaseMetaRepository<D2UserGroup> {
  /// Constructs a new [D2UserGroupRepository] instance with the given database.
  D2UserGroupRepository(super.db);

  /// Retrieves the unique identifier for a [D2UserGroup] by its UID [uid].
  ///
  /// - [uid] The DHIS2 unique indentifier of the user group.
  ///
  /// Returns the unique identifier as an [int] or `null` if not found.
  @override
  int? getIdByUid(String uid) {
    return getByUid(uid)?.id;
  }

  /// Retrieves a [D2UserGroup] instance by its UID [uid].
  ///
  /// - [uid] The DHIS2 unique indentifier of the user group.
  ///
  /// Returns the [D2UserGroup] instance or `null` if not found.
  @override
  D2UserGroup? getByUid(String uid) {
    Query<D2UserGroup> query = box.query(D2UserGroup_.uid.equals(uid)).build();
    return query.findFirst();
  }

  /// Maps a JSON object to a [D2UserGroup] instance.
  ///
  /// - [json] The JSON map containing user group data.
  ///
  /// Returns the mapped [D2UserGroup] instance.
  @override
  D2UserGroup mapper(Map<String, dynamic> json) {
    return D2UserGroup.fromMap(db, json);
  }
}
