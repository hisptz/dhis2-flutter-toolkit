import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/option_set.dart';
import '../../repositories/metadata/tracked_entity_attribute.dart';
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

  String? formName;
  String shortName;
  String? description;
  String aggregationType;
  String valueType;
  bool? zeroIsSignificant;
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
      );

  D2TrackedEntityAttribute.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"]),
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
        zeroIsSignificant = json["zeroIsSignificant"]
         {
    id = D2TrackedEntityAttributeRepository(db).getIdByUid(json["id"]) ?? 0;
    List<D2LegendSet> legendSet = json["attributeValues"]
        .cast<Map>()
        .map<D2LegendSet>((Map json) => D2LegendSet.fromMap(db, json))
        .toList();

    legendSets.addAll(legendSet);
    if (json["optionSet"] != null) {
      optionSet.target =
          D2OptionSetRepository(db).getByUid(json["optionSet"]["id"]);
    }
  }

  @override
  String? displayName;
  String? displayFormName;
}
