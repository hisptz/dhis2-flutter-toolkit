import '../../../objectbox.g.dart';
import '../../models/metadata/data_set.dart';
import '../../models/metadata/data_set_section.dart';
import 'base.dart';
import 'data_set.dart';
import 'data_set_section_data_element.dart';

class D2DataSetSectionRepository extends BaseMetaRepository<D2DataSetSection> {
  D2DataSetSectionRepository(super.db);

  @override
  D2DataSetSection? getByUid(String uid) {
    return box.query(D2DataSetSection_.uid.equals(uid)).build().findFirst();
  }

  @override
  D2DataSetSection mapper(Map<String, dynamic> json) {
    return D2DataSetSection.fromMap(db, json);
  }

  @override
  Future<List<D2DataSetSection>> saveOffline(
      List<Map<String, dynamic>> json) async {
    if (json.isEmpty) return [];

    final dataSetUid = ((json.first['dataSet'] as Map)['id'] as String);
    final dataSet = D2DataSetRepository(db).getByUid(dataSetUid);

    if (dataSet != null) {
      final existing = await box
          .query(D2DataSetSection_.dataSet.equals(dataSet.id))
          .build()
          .findAsync();

      if (existing.isNotEmpty) {
        final junctionIds = <int>[];
        for (final section in existing) {
          junctionIds.addAll(
              section.dataSetSectionDataElements.map((e) => e.id));
        }
        if (junctionIds.isNotEmpty) {
          await D2DataSetSectionDataElementRepository(db)
              .box
              .removeManyAsync(junctionIds);
        }
        await box.removeManyAsync(existing.map((s) => s.id).toList());
      }
    }
    return await super.saveOffline(json);
  }

  /// Returns sections for a dataset sorted by their DHIS2-defined sort order.
  List<D2DataSetSection> getByDataSet(D2DataSet dataSet) {
    final sections = box
        .query(D2DataSetSection_.dataSet.equals(dataSet.id))
        .build()
        .find();
    sections.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return sections;
  }
}
