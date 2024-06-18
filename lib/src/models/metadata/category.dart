import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:objectbox/objectbox.dart';

import './base.dart';

/// This class represents a category in DHIS2.
@Entity()
class D2Category extends D2MetaResource {
  @override
  int id = 0;
  DateTime created;

  DateTime lastUpdated;

  @override
  @Unique()
  String uid;
  String name;
  String? code;
  String shortName;
  String dataDimensionType;

  @Backlink('category')
  final categoryOptions = ToMany<D2CategoryOption>();

  /// Creates a new instance of [D2Category].
  ///
  /// - [id]: The ID of the category.
  /// - [shortName]: The short name of the category.
  /// - [lastUpdated]: The date and time when the category was last updated.
  /// - [name]: The name of the category.
  /// - [code]: The code of the category.
  /// - [created]: The date and time when the category was created.
  /// - [dataDimensionType]: The data dimension type of the category.
  /// - [uid]: The UID of the category.
  D2Category(
    this.id,
    this.shortName,
    this.lastUpdated,
    this.name,
    this.code,
    this.created,
    this.dataDimensionType,
    this.uid,
  );

  /// Creates a [D2Category] instance from a map.
  ///
  /// - [db]: The ObjectBox database instance.
  /// - [json]: The map containing the category data.
  D2Category.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json['created']),
        lastUpdated = DateTime.parse(json['lastUpdated']),
        uid = json['id'],
        name = json['name'],
        code = json['code'],
        dataDimensionType = json['dataDimensionType'],
        shortName = json['shortName'] {
    id = D2CategoryRepository(db).getIdByUid(json["id"]) ?? 0;

    List<D2CategoryOption> options = json['categoryOptions']
        .cast<Map>()
        .map((Map json) => D2CategoryOptionRepository(db).getByUid(json['id']))
        .toList()
        .cast<D2CategoryOption>();
    categoryOptions.addAll(options);
  }
}
