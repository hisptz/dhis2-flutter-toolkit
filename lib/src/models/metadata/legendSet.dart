import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/legendSet.dart';
import 'base.dart';
import 'legend.dart';

@Entity()
class D2LegendSet extends D2MetaResource {
  @override
  int id = 0;
  @override
  DateTime created;

  @override
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

  D2LegendSet.fromMap(ObjectBox db, Map json)
      : created = DateTime.parse(json["created"]),
        lastUpdated = DateTime.parse(json["lastUpdated"]),
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
