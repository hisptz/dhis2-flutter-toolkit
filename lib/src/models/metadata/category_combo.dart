import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:objectbox/objectbox.dart';

import 'base.dart';

/// This class represents a category combination in DHIS2.
@Entity()
class D2CategoryCombo extends D2MetaResource {
  @override
  int id = 0;
  DateTime created;

  DateTime lastUpdated;

  @override
  @Unique()
  String uid;

  String name;
  String? code;
  bool skipTotal;

  String dataDimensionType;

  @Backlink('categoryCombo')
  final categoryOptionCombos = ToMany<D2CategoryOptionCombo>();

  /// The list of categories associated with this category combination.
  final categories = ToMany<D2Category>();

  /// Creates a new instance of [D2CategoryCombo].
  ///
  /// - [lastUpdated] The date and time when the category combination was last updated.
  /// - [uid] The UID of the category combination.
  /// - [created] The date and time when the category combination was created.
  /// - [name] The name of the category combination.
  /// - [code] The code of the category combination.
  /// - [id] The ID of the category combination.
  /// - [skipTotal] Whether to skip the total value when processing this category combination.
  /// - [dataDimensionType] The data dimension type of the category combination.
  D2CategoryCombo(
    this.lastUpdated,
    this.uid,
    this.created,
    this.name,
    this.code,
    this.id,
    this.skipTotal,
    this.dataDimensionType,
  );

  /// Creates a [D2CategoryCombo] instance from a map.
  ///
  /// - [db] The ObjectBox database instance.
  /// - [json] The map containing the category combination data.
  D2CategoryCombo.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"]),
        uid = json["id"],
        name = json["name"],
        code = json["code"],
        dataDimensionType = json["dataDimensionType"],
        skipTotal = json['skipTotal'] {
    id = D2CategoryComboRepository(db).getIdByUid(json['id']) ?? 0;

    List<D2Category> categories = json['categories']
        .cast<Map>()
        .map((Map json) => D2CategoryRepository(db).getByUid(json['id']))
        .toList()
        .cast<D2Category>();

    this.categories.addAll(categories);
  }
}
