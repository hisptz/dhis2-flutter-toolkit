import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/system_info.dart';
import 'base.dart';

@Entity()

/// This class represents the DHIS2 system information.
///
/// This class includes properties for various system information such as version, revision, calendar, etc.
class D2SystemInfo extends D2MetaResource {
  @override
  int id = 0;

  /// The version of the system.
  String version;

  /// The revision of the system.
  String revision;

  /// The calendar used by the system.
  String calendar;

  /// The date format used by the system.
  String dateFormat;

  /// The context path of the system.
  String contextPath;

  /// The unique system ID.
  @Unique()
  String systemId;

  /// The name of the system.
  @Index()
  String systemName;

  /// Constructs a [D2SystemInfo] instance with the specified parameters.
  ///
  /// - [id] is the unique identifier for the system info.
  /// - [version] is the version of the system.
  /// - [revision] is the revision of the system.
  /// - [calendar] is the calendar used by the system.
  /// - [dateFormat] is the date format used by the system.
  /// - [contextPath] is the context path of the system.
  /// - [systemId] is the unique system ID.
  /// - [systemName] is the name of the system.
  D2SystemInfo(this.id, this.version, this.revision, this.calendar,
      this.dateFormat, this.contextPath, this.systemId, this.systemName);

  /// Constructs a [D2SystemInfo] instance from a JSON map.
  ///
  /// - [db] is the instance of [D2ObjectBox].
  /// - [json] is the JSON map containing the system information.
  D2SystemInfo.fromMap(D2ObjectBox db, Map json)
      : calendar = json["calendar"],
        revision = json["revision"],
        dateFormat = json["dateFormat"],
        version = json["version"],
        contextPath = json["contextPath"],
        systemName = json["systemName"],
        systemId = json["systemId"] {
    id = D2SystemInfoRepository(db).getIdByUid(json["systemId"]) ?? 0;
  }

  /// The date and time when the system info was created.
  @override
  DateTime created = DateTime.now();

  /// The display name of the system info.
  @override
  String? displayName = "";

  /// The date and time when the system info was last updated.
  @override
  DateTime lastUpdated = DateTime.now();

  /// The unique identifier for the system info.
  @override
  String uid = "";
}
