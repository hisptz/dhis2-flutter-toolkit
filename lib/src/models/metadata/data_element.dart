
import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import '../../repositories/metadata/data_element.dart';
import '../../repositories/metadata/option_set.dart';
import 'base.dart';
import 'legend_set.dart';
import 'option_set.dart';

@Entity()
class D2DataElement extends D2MetaResource {
  @override
  DateTime created;
  @override
  DateTime lastUpdated;

  @override
  @Unique()
  String uid;

  String name;
  String? code;
  String? displayFormName;
  @override
  String? displayName;

  String? formName;
  String shortName;
  String? description;
  String aggregationType;
  String valueType;
  String domainType;
  bool? zeroIsSignificant;
  final legendSets = ToMany<D2LegendSet>();
  final optionSet = ToOne<D2OptionSet>();

  D2DataElement(
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
      this.domainType,
      this.zeroIsSignificant,
      this.displayFormName,
      this.displayName);

  D2DataElement.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"]),
        uid = json["id"],
        name = json["name"],
        code = json["code"],
        formName = json["formName"],
        shortName = json["shortName"],
        description = json["description"],
        aggregationType = json["aggregationType"],
        valueType = json["valueType"],
        domainType = json["domainType"],
        displayFormName = json["displayFormName"],
        displayName = json["displayName"],
        zeroIsSignificant = json["zeroIsSignificant"] {
    id = D2DataElementRepository(db).getIdByUid(json["id"]) ?? 0;

    if (json["optionSet"] != null) {
      optionSet.target =
          D2OptionSetRepository(db).getByUid(json["optionSet"]["id"]);
    }
  }

  @override
  int id = 0;
}
