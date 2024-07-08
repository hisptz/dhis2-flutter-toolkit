import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/option_set.dart';
import 'base.dart';
import 'option.dart';

@Entity()

/// This class represents an option set in a DHIS2 system, extending [D2MetaResource].
class D2OptionSet extends D2MetaResource {
  @override
  int id = 0;
  @override
  DateTime created;

  @override
  DateTime lastUpdated;

  @override
  String uid;

  /// The name of the option set.
  String name;

  /// The code of the option set (optional).
  String? code;

  /// The value type of the option set.
  String valueType;

  @Backlink("optionSet")
  final options = ToMany<D2Option>();

  /// Constructs a [D2OptionSet].
  ///
  /// Parameters:
  /// - [id] The identifier of the option set.
  /// - [displayName] The display name of the option set.
  /// - [created] The creation date of the option set.
  /// - [lastUpdated] The last update date of the option set.
  /// - [uid] The unique identifier of the option set.
  /// - [name] The name of the option set.
  /// - [code] The code of the option set.
  /// - [valueType] The value type of the option set.
  D2OptionSet(this.id, this.displayName, this.created, this.lastUpdated,
      this.uid, this.name, this.code, this.valueType);

  /// Constructs a [D2OptionSet] from a map [json].
  ///
  /// Parameters:
  /// - [db] The [D2ObjectBox] instance.
  /// - [json] The map containing the option set data.
  D2OptionSet.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"]),
        uid = json["id"],
        name = json["name"],
        code = json["code"],
        valueType = json["valueType"],
        displayName = json["displayName"] {
    id = D2OptionSetRepository(db).getIdByUid(json["id"]) ?? 0;
  }

  @override
  String? displayName;
}
