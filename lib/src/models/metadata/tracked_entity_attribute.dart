import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/entry.dart';
import 'base.dart';
import 'legend_set.dart';
import 'option_set.dart';

@Entity()
class D2TrackedEntityAttribute extends D2MetaResource {
  @override
  int id = 0;
  @override
  DateTime created;

  @override
  DateTime lastUpdated;

  @override
  @Unique()
  String uid;

  String name;
  String? code;
  String? pattern;

  String? formName;
  String shortName;
  String? description;
  String? aggregationType;
  String valueType;
  bool? zeroIsSignificant;
  bool? generated;
  bool? optionSetValue;
  final legendSets = ToMany<D2LegendSet>();
  final optionSet = ToOne<D2OptionSet>();

  D2TrackedEntityAttribute(
      this.created,
      this.lastUpdated,
      this.uid,
      this.name,
      this.code,
      this.formName,
      this.shortName,
      this.description,
      this.aggregationType,
      this.valueType,
      this.zeroIsSignificant,
      this.generated,
      this.pattern,
      this.optionSetValue);

  D2TrackedEntityAttribute.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json["created"] ?? json["createdAt"]),
        lastUpdated = DateTime.parse(json["lastUpdated"] ?? json["updatedAt"]),
        uid = json["id"],
        name = json["name"],
        code = json["code"],
        formName = json["formName"],
        shortName = json["shortName"],
        displayName = json["displayName"],
        displayFormName = json["displayFormName"],
        description = json["description"],
        aggregationType = json["aggregationType"],
        valueType = json["valueType"],
        zeroIsSignificant = json["zeroIsSignificant"],
        generated = json["generated"],
        pattern = json["pattern"],
        optionSetValue = json["optionSetValue"] {
    id = D2TrackedEntityAttributeRepository(db).getIdByUid(json["id"]) ?? 0;
    if (json['legendSets'] != null) {
      List<D2LegendSet?> sets = json['legendSets']
          .map<D2LegendSet?>(
              (json) => D2LegendSetRepository(db).getByUid(json['id']))
          .toList();

      List<D2LegendSet> nonNullSets =
          sets.where((legend) => legend != null).cast<D2LegendSet>().toList();
      legendSets.addAll(nonNullSets);
    }
    if (json["optionSet"] != null) {
      optionSet.target =
          D2OptionSetRepository(db).getByUid(json["optionSet"]["id"]);
    }
  }

  @override
  String? displayName;
  String? displayFormName;
}
