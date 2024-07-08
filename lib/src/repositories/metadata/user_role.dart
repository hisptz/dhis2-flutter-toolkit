import '../../../objectbox.g.dart';

import '../../models/metadata/user_role.dart';
import 'base.dart';

/// This is a repository class for managing [D2UserRole] instances.
class D2UserRoleRepository extends BaseMetaRepository<D2UserRole> {
  /// Constructs a [D2UserRoleRepository] with the given [db].
  D2UserRoleRepository(super.db);

  /// Retrieves the ID of a [D2UserRole] by its [uid].
  ///
  /// - [uid] The DHIS2 unique indentifier of the user role.
  ///
  /// Returns the ID if found, otherwise null.
  @override
  int? getIdByUid(String uid) {
    return getByUid(uid)?.id;
  }

  /// Retrieves a [D2UserRole] by its [uid].
  ///
  /// - [uid] The DHIS2 unique indentifier of the user role.
  ///
  /// Returns the [D2UserRole] if found, otherwise null.
  @override
  D2UserRole? getByUid(String uid) {
    Query<D2UserRole> query = box.query(D2UserRole_.uid.equals(uid)).build();
    return query.findFirst();
  }

  /// Maps a JSON object to a [D2UserRole] instance.
  ///
  /// - [json] A map representing the user role data.
  ///
  /// Returns the mapped [D2UserRole].
  @override
  D2UserRole mapper(Map<String, dynamic> json) {
    return D2UserRole.fromMap(db, json);
  }
}
