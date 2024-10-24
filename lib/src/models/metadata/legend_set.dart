import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/legend_set.dart';
import 'base.dart';
import 'legend.dart';

@Entity()
class D2LegendSet extends D2MetaResource {
  @override
  int id = 0;
  DateTime created;

  DateTime lastUpdated;

  @override
  @Unique()
  String uid;

  String name;
  String? code;

  @Backlink("legendSet")
  final legends = ToMany<D2Legend>();

  D2LegendSet(this.id, this.created, this.lastUpdated, this.uid, this.name,
      this.code, this.displayName);

  D2LegendSet.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json["created"] ?? json["createdAt"]),
        lastUpdated = DateTime.parse(json["lastUpdated"] ?? json["updatedAt"]),
        uid = json["id"],
        name = json["name"],
        code = json["code"],
        displayName = json["displayName"] {
    List<D2Legend> allLegends = json["legends"]
        .cast<Map>()
        .map<D2Legend>((Map json) => D2Legend.fromMap(db, json))
        .toList();
    legends.addAll(allLegends);

    id = D2LegendSetRepository(db).getIdByUid(json["id"]) ?? 0;
  }

  @override
  String? displayName;
}
