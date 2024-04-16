import '../../../objectbox.dart';
import '../../../objectbox.g.dart';
import '../../models/data/data_store.dart';

class D2DataStoreRepository {
  D2ObjectBox db;
  String namespace;

  Condition<D2DataStore> conditions;

  Box<D2DataStore> get box {
    return db.store.box<D2DataStore>();
  }

  D2DataStoreRepository({required this.db, required this.namespace})
      : conditions = D2DataStore_.namespace.equals(namespace);

  List<String> get keys {
    List<D2DataStore> stores = box.query(conditions).build().find();
    return stores.map((store) => store.key).toList();
  }

  D2DataStore? getByKey(String key) {
    return box
        .query(conditions.and(D2DataStore_.key.equals(key)))
        .build()
        .findFirst();
  }


}
