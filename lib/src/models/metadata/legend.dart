import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/legend.dart';
import 'base.dart';
import 'legend_set.dart';

@Entity()

/// This class represents a legend entity with start and end values, color, and metadata.
class D2Legend extends D2MetaResource {
  /// The unique identifier for the legend.
  @override
  int id = 0;

  /// The creation timestamp of the legend.
  DateTime created;

  /// The last updated timestamp of the legend.
  DateTime lastUpdated;

  /// The unique UID of the legend.
  @override
  String uid;

  /// The name of the legend.
  String name;

  /// The start value of the legend range.
  double startValue;

  /// The end value of the legend range.
  double endValue;

  /// The color associated with the legend, represented as a hex string.
  String color;

  /// An optional display name for the legend.
  String? displayName;

  /// The relationship to the legend set that this legend belongs to.
  final legendSet = ToOne<D2LegendSet>();

  /// Constructs a new instance of the [D2Legend] class.
  ///
  /// - [created]: The creation timestamp of the legend.
  /// - [lastUpdated]: The last updated timestamp of the legend.
  /// - [uid]: The unique UID of the legend.
  /// - [name]: The name of the legend.
  /// - [startValue]: The start value of the legend range.
  /// - [endValue]: The end value of the legend range.
  /// - [color]: The color associated with the legend, represented as a hex string.
  /// - [displayName]: An optional display name for the legend.
  D2Legend(this.created, this.lastUpdated, this.uid, this.name, this.startValue,
      this.endValue, this.color, this.displayName);

  /// Constructs a new instance of the [D2Legend] class from a map of JSON data [json].
  ///
  /// - [db]: The ObjectBox database instance.
  /// - [json]: The JSON map containing the legend data.
  D2Legend.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"]),
        uid = json["id"],
        name = json["name"],
        startValue = json["startValue"].toDouble(),
        endValue = json["endValue"].toDouble(),
        color = json["color"],
        displayName = json["displayName"] {
    id = D2LegendRepository(db).getIdByUid(json["id"]) ?? 0;
  }
}
