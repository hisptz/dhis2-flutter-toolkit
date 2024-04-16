import 'package:dhis2_flutter_toolkit/src/repositories/data/base.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/data/download_mixin/data_store_data_download_service_mixin.dart';

import '../../../objectbox.g.dart';
import '../../models/data/data_store.dart';

class D2DataStoreRepository extends BaseDataRepository
    with D2DataStoreDataDownloadServiceMixin {
  String? namespace;

  Condition<D2DataStore>? conditions;

  Box<D2DataStore> get box {
    return db.store.box<D2DataStore>();
  }

  D2DataStoreRepository(super.db, {this.namespace})
      : conditions =
            namespace != null ? D2DataStore_.namespace.equals(namespace) : null;

  List<String> get keys {
    List<D2DataStore> stores = box.query(conditions).build().find();
    return stores.map((store) => store.key).toList();
  }

  setNamespace(String namespace) {
    this.namespace = namespace;
  }

  D2DataStore? getByKey(String key) {
    if (namespace == null) {
      throw "You must set the namespace first";
    }
    return box
        .query(conditions?.and(D2DataStore_.key.equals(key)))
        .build()
        .findFirst();
  }

  int? getIdByUid(String uid) {
    return box.query(D2DataStore_.uid.equals(uid)).build().findFirst()?.id;
  }
}
