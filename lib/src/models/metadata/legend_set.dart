import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/legend_set.dart';
import 'base.dart';
import 'legend.dart';

@Entity()

/// This class represents a set of legends in the system.
class D2LegendSet extends D2MetaResource {
  /// Unique identifier for the legend set.
  @override
  int id = 0;

  /// The date and time when the legend set was created.
  DateTime created;

  /// The date and time when the legend set was last updated.
  DateTime lastUpdated;

  /// Unique identifier string for the legend set.
  @override
  @Unique()
  String uid;

  /// The name of the legend set.
  String name;

  /// An optional code associated with the legend set.
  String? code;

  /// A collection of legends associated with this legend set.
  @Backlink("legendSet")
  final legends = ToMany<D2Legend>();

  /// The display name of the legend set.
  @override
  String? displayName;

  /// Constructs a new instance of the [D2LegendSet] class.
  ///
  /// - [id]: The unique identifier for the legend set.
  /// - [created]: The creation date and time.
  /// - [lastUpdated]: The last update date and time.
  /// - [uid]: The unique identifier string.
  /// - [name]: The name of the legend set.
  /// - [code]: An optional code for the legend set.
  /// - [displayName]: The display name of the legend set.
  D2LegendSet(this.id, this.created, this.lastUpdated, this.uid, this.name,
      this.code, this.displayName);

  /// Constructs a new instance of the [D2LegendSet] class from a JSON map.
  ///
  /// - [db]: The ObjectBox database instance.
  /// - [json]: The JSON map containing the legend set data.
  ///
  /// This constructor parses the JSON map to initialize the legend set properties and
  /// populates the [legends] collection with legends from the JSON map.
  D2LegendSet.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"]),
        uid = json["id"],
        name = json["name"],
        code = json["code"],
        displayName = json["displayName"] {
    List<D2Legend> allLegends = json["legends"]
        .cast<Map>()
        .map<D2Legend>((Map json) => D2Legend.fromMap(db, json))
        .toList();
    legends.addAll(allLegends);

    id = D2LegendSetRepository(db).getIdByUid(json["id"]) ?? 0;
  }
}
