import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:objectbox/objectbox.dart';

import 'base.dart';

@Entity()
class D2OptionGroup extends D2MetaResource {
  @override
  int id = 0;

  DateTime created;

  DateTime lastUpdated;

  @Unique()
  @override
  String uid;

  String name;
  String? code;

  @Backlink("optionGroups")
  final options = ToMany<D2Option>();

  final optionSet = ToOne<D2OptionSet>();

  D2OptionGroup(
    this.id,
    this.created,
    this.lastUpdated,
    this.uid,
    this.name,
    this.code,
  );

  D2OptionGroup.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json["created"] ?? json["createdAt"]),
        lastUpdated = DateTime.parse(json["lastUpdated"] ?? json["updatedAt"]),
        uid = json["id"],
        name = json["name"],
        code = json["code"] {
    id = D2OptionGroupRepository(db).getIdByUid(json["id"]) ?? 0;

    if (json['optionSet'] != null) {
      optionSet.target =
          D2OptionSetRepository(db).getByUid(json['optionSet']['id']);
    }

    if (json['options'] != null) {
      List<D2Option> d2Options = json['options']
          .cast<Map>()
          .map((Map optionMap) =>
              D2OptionRepository(db).getByUid(optionMap['id']))
          .where((option) => option != null)
          .toList()
          .cast<D2Option>();
      options.addAll(d2Options);
    }
  }
}
