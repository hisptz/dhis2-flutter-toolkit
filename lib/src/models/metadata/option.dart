import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:dhis2_flutter_toolkit/src/models/metadata/option_group.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/option.dart';
import '../../repositories/metadata/option_set.dart';
import 'base.dart';
import 'option_set.dart';

@Entity()
class D2Option extends D2MetaResource {
  @override
  int id = 0;
  DateTime created;

  DateTime lastUpdated;

  @override
  String uid;

  String name;
  String code;
  String? color;
  String? icon;
  int sortOrder;

  final optionSet = ToOne<D2OptionSet>();
  final optionGroups = ToMany<D2OptionGroup>();

  D2Option(this.id, this.created, this.lastUpdated, this.uid, this.name,
      this.code, this.sortOrder, this.displayName, this.color, this.icon);

  D2Option.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json["created"] ?? json["createdAt"]),
        lastUpdated = DateTime.parse(json["lastUpdated"] ?? json["updatedAt"]),
        uid = json["id"],
        name = json["name"],
        code = json["code"],
        color = json["style"]?["color"],
        icon = json["style"]?["icon"],
        sortOrder = json["sortOrder"],
        displayName = json["displayName"] {
    id = D2OptionRepository(db).getIdByUid(json["id"]) ?? 0;
    optionSet.target =
        D2OptionSetRepository(db).getByUid(json["optionSet"]["id"]);
  }

  String? displayName;
}
