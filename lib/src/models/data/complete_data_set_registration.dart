import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:objectbox/objectbox.dart';

import 'base.dart';
import 'base_deletable.dart';

@Entity()
class D2CompleteDataSetRegistration extends SyncDataSource
    implements D2BaseDeletable {
  @override
  int id = 0;

  @override
  DateTime createdAt;

  @override
  DateTime updatedAt;

  @override
  bool synced = true;

  @override
  @Unique()
  late String uid;

  String period;

  String? date;

  String? storedBy;

  bool completed;

  final dataSet = ToOne<D2DataSet>();
  final organisationUnit = ToOne<D2OrgUnit>();
  final attributeOptionCombo = ToOne<D2CategoryOptionCombo>();

  D2CompleteDataSetRegistration(
    this.id,
    this.createdAt,
    this.updatedAt,
    this.period,
    this.date,
    this.storedBy,
    this.completed,
  );

  D2CompleteDataSetRegistration.fromMap(D2ObjectBox db, Map json)
      : createdAt = DateTime.tryParse(json["date"] ?? '') ?? DateTime.now(),
        updatedAt = DateTime.now(),
        period = json['period'] ?? '',
        date = json['date'],
        storedBy = json['storedBy'],
        completed = json['completed'] ?? true {
    dataSet.target = D2DataSetRepository(db).getByUid(json["dataSet"] ?? '');
    organisationUnit.target =
        D2OrgUnitRepository(db).getByUid(json["organisationUnit"] ?? '');
    attributeOptionCombo.target = D2CategoryOptionComboRepository(db)
        .getByUid(json["attributeOptionCombo"] ?? '');

    uid = _buildUid(
      dataSetUid: dataSet.target?.uid ?? json["dataSet"] ?? '',
      period: period,
      orgUnitUid:
          organisationUnit.target?.uid ?? json["organisationUnit"] ?? '',
      aocUid: attributeOptionCombo.target?.uid ??
          json["attributeOptionCombo"] ??
          '',
    );

    id = D2CompleteDataSetRegistrationRepository(db).getIdByUid(uid) ?? 0;
  }

  D2CompleteDataSetRegistration.fromForm({
    required D2ObjectBox db,
    required D2DataSet dataSetObj,
    required D2OrgUnit orgUnit,
    required D2CategoryOptionCombo aoc,
    required this.period,
    required this.completed,
    this.storedBy,
  })  : createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        date = DateTime.now().toIso8601String().split('T').first {
    dataSet.target = dataSetObj;
    organisationUnit.target = orgUnit;
    attributeOptionCombo.target = aoc;

    uid = _buildUid(
      dataSetUid: dataSetObj.uid,
      period: period,
      orgUnitUid: orgUnit.uid,
      aocUid: aoc.uid,
    );

    id = D2CompleteDataSetRegistrationRepository(db).getIdByUid(uid) ?? 0;
    synced = false;
  }

  static String _buildUid({
    required String dataSetUid,
    required String period,
    required String orgUnitUid,
    required String aocUid,
  }) {
    return '$dataSetUid-$period-$orgUnitUid-$aocUid';
  }

  @override
  Future<Map<String, dynamic>> toMap({D2ObjectBox? db}) async {
    return {
      "dataSet": dataSet.target?.uid,
      "period": period,
      "organisationUnit": organisationUnit.target?.uid,
      "attributeOptionCombo": attributeOptionCombo.target?.uid,
      "date": date,
      "storedBy": storedBy,
      "completed": completed,
    };
  }

  @override
  bool delete(D2ObjectBox db) {
    return D2CompleteDataSetRegistrationRepository(db).box.remove(id);
  }

  @override
  void softDelete(db) {}
}
