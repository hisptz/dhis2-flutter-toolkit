import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/legend.dart';
import 'base.dart';
import 'legend_set.dart';

@Entity()
class D2Legend extends D2MetaResource {
  @override
  int id = 0;
  DateTime created;

  DateTime lastUpdated;

  @override
  String uid;

  String name;
  double startValue;
  double endValue;
  String color;

  String? displayName;

  final legendSet = ToOne<D2LegendSet>();

  D2Legend(this.created, this.lastUpdated, this.uid, this.name, this.startValue,
      this.endValue, this.color, this.displayName);

  D2Legend.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json["created"] ?? json["createdAt"]),
        lastUpdated = DateTime.parse(json["lastUpdated"] ?? json["updatedAt"]),
        uid = json["id"],
        name = json["name"],
        startValue = json["startValue"].toDouble(),
        endValue = json["endValue"].toDouble(),
        color = json["color"],
        displayName = json["displayName"] {
    id = D2LegendRepository(db).getIdByUid(json["id"]) ?? 0;
  }
}
