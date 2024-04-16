import 'dart:convert';

import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import '../../repositories/data/data_store.dart';

@Entity()
class D2DataStore {
  int id = 0;
  @Index()
  String key;

  @Index()
  String namespace;

  @Unique()
  String uid;

  String value;

  D2DataStore(this.key, this.namespace, this.value, this.uid);

  D2DataStore.fromMap(D2ObjectBox db,
      {required this.namespace, required this.key, required Object value})
      : value = jsonEncode(value),
        uid = "$namespace-$key" {
    id = D2DataStoreRepository(db).getIdByUid(uid) ?? 0;
  }

  getValue<T>() {
    return jsonDecode(value) as T;
  }
}
