import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:dhis2_flutter_toolkit/src/models/metadata/option_group.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/option.dart';
import '../../repositories/metadata/option_set.dart';
import 'base.dart';
import 'option_set.dart';

@Entity()

/// This class represents an option in a metadata system, inheriting from [D2MetaResource].
class D2Option extends D2MetaResource {
  @override
  int id = 0;

  @override
  DateTime created;

  @override
  DateTime lastUpdated;

  @override
  String uid;

  /// Name of the option.
  String name;

  /// Code of the option.
  String code;

  /// Sort order of the option.
  int sortOrder;

  /// The related option set.
  final optionSet = ToOne<D2OptionSet>();

  /// The related option groups.
  final optionGroups = ToMany<D2OptionGroup>();

  /// Constructs a [D2Option].
  ///
  /// Parameters:
  /// - [id]: Unique identifier of the option.
  /// - [created]: Creation date of the option.
  /// - [lastUpdated]: Last updated date of the option.
  /// - [uid]: Unique UID of the option.
  /// - [name]: Name of the option.
  /// - [code]: Code of the option.
  /// - [sortOrder]: Sort order of the option.
  /// - [displayName]: Display name of the option.
  D2Option(this.id, this.created, this.lastUpdated, this.uid, this.name,
      this.code, this.sortOrder, this.displayName);

  /// Constructs a [D2Option] from a JSON map.
  ///
  /// Parameters:
  /// - [db]: Instance of [D2ObjectBox].
  /// - [json]: JSON map containing the option data.
  D2Option.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"]),
        uid = json["id"],
        name = json["name"],
        code = json["code"],
        sortOrder = json["sortOrder"],
        displayName = json["displayName"] {
    id = D2OptionRepository(db).getIdByUid(json["id"]) ?? 0;
    optionSet.target =
        D2OptionSetRepository(db).getByUid(json["optionSet"]["id"]);
  }

  @override
  String? displayName;
}
