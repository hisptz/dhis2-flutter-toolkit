import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/system_info.dart';
import 'base.dart';

@Entity()
class D2SystemInfo extends D2MetaResource {
  @override
  int id = 0;

  String version;
  String revision;
  String calendar;
  String dateFormat;
  String contextPath;
  @Index()
  String? systemId;
  @Index()
  String systemName;

  D2SystemInfo(this.id, this.version, this.revision, this.calendar,
      this.dateFormat, this.contextPath, this.systemId, this.systemName);

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

  @override
  String uid = "";
}
