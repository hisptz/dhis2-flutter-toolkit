import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:objectbox/objectbox.dart';

import 'base.dart';

@Entity()
class D2DataElement extends D2MetaResource {
  DateTime created;
  DateTime lastUpdated;

  @override
  @Unique()
  String uid;

  String name;
  String? code;
  String? displayFormName;
  String? displayName;

  String? formName;
  String shortName;
  String? description;
  String aggregationType;
  String valueType;
  String domainType;
  bool? zeroIsSignificant;
  bool? optionSetValue;
  final legendSets = ToMany<D2LegendSet>();
  final optionSet = ToOne<D2OptionSet>();
  final categoryCombo = ToOne<D2CategoryCombo>();
  final dataValues = ToMany<D2DataValueSet>();

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
      this.displayName,
      this.optionSetValue);

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
        zeroIsSignificant = json["zeroIsSignificant"],
        optionSetValue = json["optionSetValue"] {
    id = D2DataElementRepository(db).getIdByUid(json["id"]) ?? 0;

    if (json["optionSet"] != null) {
      optionSet.target =
          D2OptionSetRepository(db).getByUid(json["optionSet"]["id"]);
    }
    if (json['categoryCombo'] != null) {
      categoryCombo.target =
          D2CategoryComboRepository(db).getByUid(json['categoryCombo']['id']);
    }

    if (json['legendSets'] != null) {
      List<D2LegendSet?> sets = json['legendSets']
          .map<D2LegendSet?>(
              (json) => D2LegendSetRepository(db).getByUid(json['id']))
          .toList();

      List<D2LegendSet> nonNullSets =
          sets.where((legend) => legend != null).cast<D2LegendSet>().toList();
      legendSets.addAll(nonNullSets);
    }
  }

  @override
  int id = 0;
}
