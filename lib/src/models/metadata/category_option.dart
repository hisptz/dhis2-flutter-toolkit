import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import '../../repositories/metadata/category_option.dart';
import './base.dart';
import 'category.dart';
import 'category_option_combo.dart';

@Entity()

/// This class represents a category option in DHIS2.
class D2CategoryOption extends D2MetaResource {
  @override
  int id = 0;
  DateTime created;

  DateTime lastUpdated;

  @Unique()
  @override
  String uid;

  String name;
  String? code;
  String shortName;

  /// The category associated with this category option.
  final category = ToOne<D2Category>();

  /// The category option combo associated with this category option.
  final categoryOptionCombo = ToOne<D2CategoryOptionCombo>();

  /// Creates a new instance of [D2CategoryOption].
  ///
  /// - [id] The ID of the category option.
  /// - [created] The date and time when the category option was created.
  /// - [lastUpdated] The date and time when the category option was last updated.
  /// - [uid] The UID of the category option.
  /// - [name] The name of the category option.
  /// - [code] The code of the category option.
  /// - [shortName] The short name of the category option.

  D2CategoryOption(
    this.id,
    this.created,
    this.lastUpdated,
    this.uid,
    this.name,
    this.code,
    this.shortName,
  );

  /// Creates a [D2CategoryOption] instance from a map.
  ///
  /// - [db] The ObjectBox database instance.
  /// - [json] The map containing the category option data.
  D2CategoryOption.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"]),
        uid = json["id"],
        name = json["name"],
        code = json["code"],
        shortName = json["shortName"] {
    id = D2CategoryOptionRepository(db).getIdByUid(json["id"]) ?? 0;
  }
}
