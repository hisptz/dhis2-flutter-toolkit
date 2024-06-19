import 'package:objectbox/objectbox.dart';

import '../../../objectbox.dart';
import '../../repositories/metadata/data_element.dart';
import '../../repositories/metadata/data_set.dart';
import '../../repositories/metadata/data_set_element.dart';
import 'base.dart';
import 'data_element.dart';
import 'data_set.dart';

@Entity()

/// This class represents an association between a data element and a data set in the DHIS2 system.
class D2DataSetElement implements D2MetaResource {
  @override
  int id = 0;

  @override
  @Unique()
  String uid;

  /// The data element associated with this data set element.
  final dataElement = ToOne<D2DataElement>();

  /// The data set associated with this data set element.
  final dataSet = ToOne<D2DataSet>();

  /// Creates a new instance of [D2DataSetElement].
  ///
  /// The constructor initializes the [id] and [uid] properties.
  ///
  /// - [id]: The unique identifier for the data set element.
  /// - [uid]: The unique identifier (UID) for the data set element.
  D2DataSetElement(this.id, this.uid);

  /// Creates a new instance of [D2DataSetElement] from a map.
  ///
  /// The [D2DataSetElement.fromMap] constructor initializes a [D2DataSetElement] instance using
  /// data from a [json] map and a reference to the [db] database.
  ///
  /// - [db]: The database reference for fetching related entities.
  /// - [json]: The JSON map containing the data set element information.
  D2DataSetElement.fromMap(D2ObjectBox db, Map json)
      : uid = '${json["dataSet"]["id"]}-${json["dataElement"]["id"]}' {
    String dataElementUid = json["dataElement"]["id"];
    String dataSetUid = json["dataSet"]["id"];

    id = D2DataSetElementRepository(db).getIdByUid(uid) ?? 0;
    dataElement.target = D2DataElementRepository(db).getByUid(dataElementUid);
    dataSet.target = D2DataSetRepository(db).getByUid(dataSetUid);
  }
}
