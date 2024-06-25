import 'dart:convert';

import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import '../../repositories/data/data_store.dart';

@Entity()

/// This class represents a data store in the DHIS2 system.
class D2DataStore {
  int id = 0;

  @Index()
  String key;

  @Index()
  String namespace;

  @Unique()
  String uid;

  String value;

  /// Constructs a new instance of [D2DataStore].
  ///
  /// - [key] The key associated with the data store.
  /// - [namespace] The namespace of the data store.
  /// - [value] The value stored as a JSON encoded string.
  /// - [uid] The unique identifier for the data store.
  D2DataStore(this.key, this.namespace, this.value, this.uid);

  /// Constructs a new instance of [D2DataStore] from a map.
  ///
  /// - [db] The database reference for fetching related entities.
  /// - [namespace] The namespace of the data store.
  /// - [key] The key associated with the data store.
  /// - [value] The value to be stored, which will be JSON encoded.
  D2DataStore.fromMap(D2ObjectBox db,
      {required this.namespace, required this.key, required Object value})
      : value = jsonEncode(value),
        uid = "$namespace-$key" {
    id = D2DataStoreRepository(db).getIdByUid(uid) ?? 0;
  }

  /// Retrieves the value stored in the data store.
  ///
  /// - Returns the decoded value.
  getValue<T>() {
    return jsonDecode(value) as T;
  }
}
