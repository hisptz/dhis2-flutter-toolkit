import 'package:collection/collection.dart';
import 'package:dhis2_flutter_toolkit/objectbox.dart';
import 'package:objectbox/objectbox.dart';

import '../../repositories/metadata/data_element.dart';
import '../../repositories/metadata/data_set.dart';
import '../../repositories/metadata/data_set_section.dart';
import 'base.dart';
import 'data_element.dart';
import 'data_set.dart';
import 'data_set_section_data_element.dart';

@Entity()
class D2DataSetSection extends D2MetaResource {
  @override
  int id = 0;

  DateTime created;
  DateTime lastUpdated;

  @override
  @Unique()
  String uid;

  String name;
  String? description;
  int sortOrder;

  final dataSet = ToOne<D2DataSet>();

  @Backlink('dataSetSection')
  final dataSetSectionDataElements = ToMany<D2DataSetSectionDataElement>();

  D2DataSetSection(
    this.created,
    this.lastUpdated,
    this.uid,
    this.name,
    this.sortOrder,
  );

  D2DataSetSection.fromMap(D2ObjectBox db, Map json)
      : created = DateTime.parse(json['created'] ?? json['createdAt']),
        lastUpdated = DateTime.parse(json['lastUpdated'] ?? json['updatedAt']),
        uid = json['id'] as String,
        name = json['name'] as String,
        description = json['description'] as String?,
        sortOrder = (json['sortOrder'] as num?)?.toInt() ?? 0 {
    id = D2DataSetSectionRepository(db).getIdByUid(json['id'] as String) ?? 0;

    final dataElementObjects = (json['dataElements'] as List)
        .cast<Map>()
        .map<D2DataElement?>(
            (de) => D2DataElementRepository(db).getByUid(de['id'] as String))
        .toList();

    final des = dataElementObjects
        .whereType<D2DataElement>()
        .mapIndexed<D2DataSetSectionDataElement>((index, de) =>
            D2DataSetSectionDataElement.fromSection(
              db: db,
              sortOrder: index,
              section: this,
              dataElement: de,
            ))
        .toList();

    dataSetSectionDataElements.addAll(des);
    dataSet.target = D2DataSetRepository(db)
        .getByUid((json['dataSet'] as Map)['id'] as String);
  }

  /// Data elements in the server-defined section display order.
  List<D2DataElement> get orderedDataElements {
    final items = List<D2DataSetSectionDataElement>.from(
        dataSetSectionDataElements);
    items.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return items
        .map((s) => s.dataElement.target)
        .whereType<D2DataElement>()
        .toList();
  }
}
