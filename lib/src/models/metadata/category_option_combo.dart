import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import '../../repositories/metadata/entry.dart';
import 'base.dart';
import 'category_combo.dart';
import 'category_option.dart';

@Entity()

/// This class represents a category option combo in DHIS2.
class D2CategoryOptionCombo extends D2MetaResource {
  @override
  int id = 0;
  DateTime created;

  DateTime lastUpdated;

  @override
  String uid;

  String name;
  String? code;

  /// The category combo associated with this category option combo.
  final categoryCombo = ToOne<D2CategoryCombo>();

  /// The category options associated with this category option combo.
  final categoryOptions = ToMany<D2CategoryOption>();

  /// Creates a new instance of [D2CategoryOptionCombo].
  ///
  /// - [lastUpdated]: The date and time when the category option combo was last updated.
  /// - [uid]: The UID of the category option combo.
  /// - [created]: The date and time when the category option combo was created.
  /// - [name]: The name of the category option combo.
  /// - [code]: The code of the category option combo.
  /// - [id]: The ID of the category option combo.

  D2CategoryOptionCombo(
    this.lastUpdated,
    this.uid,
    this.created,
    this.name,
    this.code,
    this.id,
  );

  /// Creates a [D2CategoryOptionCombo] instance from a map.
  ///
  /// - [db]: The ObjectBox database instance.
  /// - [json]: The map containing the category option combo data.

  D2CategoryOptionCombo.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"]),
        uid = json["id"],
        name = json["name"],
        code = json["code"] {
    id = D2CategoryOptionComboRepository(db).getIdByUid(json['id']) ?? 0;
    Map? categoryCombo = json['categoryCombo'];
    if (categoryCombo != null) {
      this.categoryCombo.target =
          D2CategoryComboRepository(db).getByUid(categoryCombo['id']);
    }

    List<D2CategoryOption> options = json['categoryOptions']
        .cast<Map>()
        .map((Map json) => D2CategoryOptionRepository(db).getByUid(json['id']))
        .toList()
        .cast<D2CategoryOption>();
    categoryOptions.addAll(options);
  }
}
