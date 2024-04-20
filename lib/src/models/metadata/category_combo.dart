import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import './base.dart';
import 'category.dart';

@Entity()
class D2CategoryCombo extends D2MetaResource {
  @override
  int id = 0;
  @override
  DateTime created;

  @override
  DateTime lastUpdated;

  @override
  String uid;

  String name;
  String code;
  bool skipTrue;

  D2CategoryCombo(
    this.lastUpdated,
    this.uid,
    this.created,
    this.name,
    this.code,
    this.id,
    this.skipTrue,
  );
}
