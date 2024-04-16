import 'dart:convert';

import 'package:objectbox/objectbox.dart';

@Entity()
class D2DataStore {
  int id = 0;

  @Unique()
  String key;

  @Index()
  String namespace;

  String value;

  D2DataStore(this.key, this.namespace, this.value);

  D2DataStore.fromMap(this.namespace, this.key, Object value)
      : value = jsonEncode(value);

  getValue<T>() {
    return jsonDecode(value) as T;
  }
}
