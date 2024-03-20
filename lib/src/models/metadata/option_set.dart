
import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/option_set.dart';
import 'base.dart';
import 'option.dart';

@Entity()
class D2OptionSet extends D2MetaResource {
  @override
  int id = 0;
  @override
  DateTime created;

  @override
  DateTime lastUpdated;

  @override
  String uid;

  String name;
  String? code;

  String valueType;

  @Backlink("optionSet")
  final options = ToMany<D2Option>();

  D2OptionSet(this.id, this.displayName, this.created, this.lastUpdated,
      this.uid, this.name, this.code, this.valueType);

  D2OptionSet.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"]),
        uid = json["id"],
        name = json["name"],
        code = json["code"],
        valueType = json["valueType"],
        displayName = json["displayName"] {
    id = D2OptionSetRepository(db).getIdByUid(json["id"]) ?? 0;
  }

  @override
  String? displayName;
}
