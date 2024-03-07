import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/option.dart';
import '../../repositories/metadata/optionSet.dart';
import 'base.dart';
import 'optionSet.dart';

@Entity()
class D2Option extends D2MetaResource {
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
  int sortOrder;

  final optionSet = ToOne<D2OptionSet>();

  D2Option(this.id, this.created, this.lastUpdated, this.uid, this.name,
      this.code, this.sortOrder, this.displayName);

  D2Option.fromMap(ObjectBox db, Map json)
      : created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"]),
        uid = json["id"],
        name = json["name"],
        code = json["code"],
        sortOrder = json["sortOrder"],
        displayName = json["displayName"] {
    id = D2OptionRepository(db).getIdByUid(json["id"]) ?? 0;
    optionSet.target =
        D2OptionSetRepository(db).getByUid(json["optionSet"]["id"]);
  }

  @override
  String? displayName;
}
