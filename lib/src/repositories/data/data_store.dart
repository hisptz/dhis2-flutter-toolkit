import 'package:dhis2_flutter_toolkit/src/repositories/data/base.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/data/download_mixin/data_store_data_download_service_mixin.dart';

import '../../../objectbox.g.dart';
import '../../models/data/data_store.dart';

/// This class handles the repository functions for [D2DataStore] in the DHIS2 system.
class D2DataStoreRepository extends BaseDataRepository
    with D2DataStoreDataDownloadServiceMixin {
  String? namespace;

  Condition<D2DataStore>? conditions;

  /// Gets the box for storing [D2DataStore] objects.
  Box<D2DataStore> get box {
    return db.store.box<D2DataStore>();
  }

  /// Constructs a new instance of [D2DataStoreRepository].
  ///
  /// - [db] The database reference.
  /// - [namespace] The namespace for the data store, optional.
  D2DataStoreRepository(super.db, {this.namespace})
      : conditions =
            namespace != null ? D2DataStore_.namespace.equals(namespace) : null;

  /// Retrieves a list of keys from the data store.
  ///
  /// Returns a list of keys as [List<String>].
  List<String> get keys {
    List<D2DataStore> stores = box.query(conditions).build().find();
    return stores.map((store) => store.key).toList();
  }

  /// Sets the namespace for the data store.
  ///
  /// - [namespace] The namespace to be set.
  setNamespace(String namespace) {
    this.namespace = namespace;
  }

  /// Retrieves a [D2DataStore] by its key.
  ///
  /// - [key] The key associated with the data store.
  ///
  /// Returns the [D2DataStore] if found, otherwise throws an exception if the namespace is not set.
  D2DataStore? getByKey(String key) {
    if (namespace == null) {
      throw "You must set the namespace first";
    }
    return box
        .query(conditions?.and(D2DataStore_.key.equals(key)))
        .build()
        .findFirst();
  }

  /// Retrieves the ID of a [D2DataStore] by its [uid].
  ///
  /// - [uid] The unique identifier of the data store.
  ///
  /// Returns the ID as an [int] if found, otherwise null.
  int? getIdByUid(String uid) {
    return box.query(D2DataStore_.uid.equals(uid)).build().findFirst()?.id;
  }
}
