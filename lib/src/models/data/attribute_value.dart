import 'package:objectbox/objectbox.dart';

import '../metadata/data_element.dart';
import '../metadata/tracked_entity_attribute.dart';

@Entity()
class D2AttributeValue {
  int id = 0;

  final dataElement = ToOne<D2DataElement>();
  final trackedEntityAttribute = ToOne<D2TrackedEntityAttribute>();
  dynamic value;

  D2AttributeValue({this.value});

  D2AttributeValue.fromMap(Map json) : value = json["value"];
}
