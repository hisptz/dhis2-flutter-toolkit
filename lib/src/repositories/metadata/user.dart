import 'base.dart';
import '../../models/metadata/user.dart';
import 'download_mixins/base_single_meta_download_mixin.dart';
import 'download_mixins/user_download_mixin.dart';

import '../../../objectbox.g.dart';

/// This is a repository class for managing [D2User] instances in the database.
class D2UserRepository extends BaseMetaRepository<D2User>
    with
        BaseSingleMetaDownloadServiceMixin<D2User>,
        D2UserDownloadServiceMixin {
  /// Creates a new [D2UserRepository] instance with the given database.
  D2UserRepository(super.db);

  /// Retrieves the unique identifier for a [D2User] by its UID [uid].
  ///
  /// - [uid] The DHIS2 unique identifier of the user.
  ///
  /// Returns the unique identifier as an [int] or `null` if not found
  @override
  int? getIdByUid(String uid) {
    return getByUid(uid)?.id;
  }

  /// Returns the [D2User] instance or `null` if not found.
  D2User? get() {
    Query query = box.query().build();
    return query.findFirst();
  }

  /// Retrieves a [D2User] instance by its UID [uid].
  ///
  /// - [uid] The unique identifier of the user.
  ///
  /// Returns the [D2User] instance or `null` if not found.
  @override
  D2User? getByUid(String uid) {
    Query<D2User> query = box.query(D2User_.uid.equals(uid)).build();
    return query.findFirst();
  }

  /// Maps a JSON object to a [D2User] instance.
  ///
  /// - [json] A map representing the user data.
  ///
  /// Returns the mapped [D2User] instance.
  @override
  D2User mapper(Map<String, dynamic> json) {
    return D2User.fromMap(db, json);
  }
}
