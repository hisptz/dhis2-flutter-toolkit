import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/entry.dart';
import 'base.dart';
import 'legend_set.dart';
import 'option_set.dart';

@Entity()

/// This class represents a tracked entity attribute entity in the DHIS2 system.
class D2TrackedEntityAttribute extends D2MetaResource {
  @override
  int id = 0;

  /// The date and time when the tracked entity attribute was created.
  @override
  DateTime created;

  /// The date and time when the tracked entity attribute was last updated.
  @override
  DateTime lastUpdated;

  /// The universally unique identifier (UUID) of the tracked entity attribute.
  @override
  @Unique()
  String uid;

  /// The name of the tracked entity attribute.
  String name;

  /// The code associated with the tracked entity attribute.
  String? code;

  /// The pattern associated with the tracked entity attribute.
  String? pattern;

  /// The form name of the tracked entity attribute.
  String? formName;

  /// The short name or abbreviation of the tracked entity attribute.
  String shortName;

  /// The description or additional information about the tracked entity attribute.
  String? description;

  /// The aggregation type used for data aggregation.
  String? aggregationType;

  /// The type of value stored in the tracked entity attribute.
  String valueType;

  /// Indicates whether zero is significant for the tracked entity attribute.
  bool? zeroIsSignificant;

  /// Indicates whether the tracked entity attribute is generated.
  bool? generated;

  /// Indicates whether the tracked entity attribute has an option set.
  bool? optionSetValue;

  /// A collection of legend sets associated with the tracked entity attribute.
  final legendSets = ToMany<D2LegendSet>();

  /// The option set associated with the tracked entity attribute.
  final optionSet = ToOne<D2OptionSet>();

  /// Constructs a new [D2TrackedEntityAttribute] with the provided parameters.
  ///
  /// - [created] The date and time when the tracked entity attribute was created.
  /// - [lastUpdated] The date and time when the tracked entity attribute was last updated.
  /// - [uid] The unique identifier (UUID) of the tracked entity attribute.
  /// - [name] The name of the tracked entity attribute.
  /// - [code] The code associated with the tracked entity attribute.
  /// - [formName] The form name of the tracked entity attribute.
  /// - [shortName] The short name or abbreviation of the tracked entity attribute.
  /// - [description] The description or additional information about the tracked entity attribute.
  /// - [aggregationType] The aggregation type used for data aggregation.
  /// - [valueType] The type of value stored in the tracked entity attribute.
  /// - [zeroIsSignificant] Indicates whether zero is significant for the tracked entity attribute.
  /// - [generated] Indicates whether the tracked entity attribute is generated.
  /// - [pattern] The pattern associated with the tracked entity attribute.
  /// - [optionSetValue] Indicates whether the tracked entity attribute has an option set.
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

  /// This constructor parses a JSON map into a [D2TrackedEntityAttribute] object.
  ///
  /// - [db] The ObjectBox database instance.
  /// - [json] The JSON map containing attribute data.
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

  /// The display name associated with the tracked entity attribute.
  String? displayName;

  /// The display form name associated with the tracked entity attribute.
  String? displayFormName;
}
