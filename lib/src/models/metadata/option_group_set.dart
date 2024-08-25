import 'package:dhis2_flutter_toolkit/src/models/metadata/base.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/metadata/option_group_set.dart';
import 'package:objectbox/objectbox.dart';

import '../../../dhis2_flutter_toolkit.dart';
import 'option_group.dart';

@Entity()
class D2OptionGroupSet extends D2MetaResource {
  @Unique()
  @override
  String uid;

  DateTime created;

  DateTime lastUpdated;

  int id = 0;

  String name;
  String? code;

  final optionSet = ToOne<D2OptionSet>();

  final optionGroups = ToMany<D2OptionGroup>();

  D2OptionGroupSet(
      this.uid, this.id, this.created, this.lastUpdated, this.name, this.code);

  D2OptionGroupSet.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json["created"] ?? json["createdAt"]),
        lastUpdated = DateTime.parse(json["lastUpdated"] ?? json["updatedAt"]),
        uid = json["id"],
        name = json["name"],
        code = json["code"] {
    id = D2OptionGroupSetRepository(db).getIdByUid(json["id"]) ?? 0;

    if (json['optionSet'] != null) {
      optionSet.target =
          D2OptionSetRepository(db).getByUid(json['optionSet']['id']);
    }

    if (json['optionGroups'] != null) {
      List<D2OptionGroup> d2OptionsGroups = json['optionGroups']
          .cast<Map>()
          .map((Map optionMap) =>
              D2OptionGroupRepository(db).getByUid(optionMap['id']))
          .toList()
          .cast<D2OptionGroup>();
      optionGroups.addAll(d2OptionsGroups);
    }
  }
}
