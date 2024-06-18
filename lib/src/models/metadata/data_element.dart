import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:objectbox/objectbox.dart';

import 'base.dart';

@Entity()

/// This class represents a data element in DHIS2.
class D2DataElement extends D2MetaResource {
  /// The date and time when the data element was created.
  DateTime created;

  /// The date and time when the data element was last updated.
  DateTime lastUpdated;

  @override
  @Unique()
  String uid;

  /// The name of the data element.
  String name;

  /// The code associated with the data element.
  String? code;

  /// The display form name of the data element.
  String? displayFormName;

  /// The display name of the data element.
  String? displayName;

  /// The form name of the data element.
  String? formName;

  /// The short name of the data element.
  String shortName;

  /// The description of the data element.
  String? description;

  /// The aggregation type of the data element.
  String aggregationType;

  /// The value type of the data element.
  String valueType;

  /// The domain type of the data element.
  String domainType;

  /// Whether zero is significant for the data element.
  bool? zeroIsSignificant;

  /// Whether the data element has an option set.
  bool? optionSetValue;

  /// The legend sets associated with the data element.
  final legendSets = ToMany<D2LegendSet>();

  /// The option set associated with the data element.
  final optionSet = ToOne<D2OptionSet>();

  /// The category combo associated with the data element.
  final categoryCombo = ToOne<D2CategoryCombo>();

  /// The data values associated with the data element.
  final dataValues = ToMany<D2DataValueSet>();

  /// Constructs a new instance of [D2DataElement].
  ///
  /// - [created]: The date and time when the data element was created.
  /// - [lastUpdated]: The date and time when the data element was last updated.
  /// - [uid]: The UID of the data element.
  /// - [name]: The name of the data element.
  /// - [code]: The code associated with the data element.
  /// - [formName]: The form name of the data element.
  /// - [shortName]: The short name of the data element.
  /// - [description]: The description of the data element.
  /// - [aggregationType]: The aggregation type of the data element.
  /// - [valueType]: The value type of the data element.
  /// - [domainType]: The domain type of the data element.
  /// - [zeroIsSignificant]: Indicates whether zero is significant for the data element.
  /// - [displayFormName]: The display form name of the data element.
  /// - [displayName]: The display name of the data element.
  /// - [optionSetValue]: Indicates whether the data element has an option set.

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

  /// Constructs a new instance of [D2DataElement] from a map.
  ///
  /// - [db]: The ObjectBox database.
  /// - [json]: The JSON map representing the data element.
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
