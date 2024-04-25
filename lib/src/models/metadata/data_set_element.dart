import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/models/metadata/base.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/metadata/data_set.dart';
import 'package:dhis2_flutter_toolkit/src/repositories/metadata/data_set_element.dart';
import 'package:objectbox/objectbox.dart';

import 'data_set.dart';

@Entity()
class D2DataSetElement implements D2MetaResource {
  @override
  int id = 0;

  @override
  @Unique()
  String uid;

  final dataElement = ToOne<D2DataElement>();
  final dataSet = ToOne<D2DataSet>();

  D2DataSetElement(this.id, this.uid);

  D2DataSetElement.fromMap(D2ObjectBox db, Map json)
      : uid = '${json["dataSet"]["id"]}-${json["dataElement"]["id"]}' {
    String dataElementUid = json["dataElement"]["id"];
    String dataSetUid = json["dataSet"]["id"];

    id = D2DataSetElementRepository(db).getIdByUid(uid) ?? 0;
    dataElement.target = D2DataElementRepository(db).getByUid(dataElementUid);
    dataSet.target = D2DataSetRepository(db).getByUid(dataSetUid);
  }
}
