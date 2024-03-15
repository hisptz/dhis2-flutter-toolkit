import 'package:dhis2_flutter_toolkit/src/models/metadata/program.dart';

import '../../../objectbox.g.dart';
import '../../models/data/tracked_entity_attribute_value.dart';
import 'base.dart';

class D2TrackedEntityAttributeValueRepository
    extends BaseDataRepository<D2TrackedEntityAttributeValue> {
  D2TrackedEntityAttributeValueRepository(super.db);

  @override
  D2TrackedEntityAttributeValue? getById(int id) {
    Query<D2TrackedEntityAttributeValue> query = box
        .query(D2TrackedEntityAttributeValue_.trackedEntityAttribute.equals(id))
        .build();
    return query.findFirst();
  }

  D2TrackedEntityAttributeValueRepository byTrackedEntity(int id) {
    queryConditions = D2TrackedEntityAttributeValue_.trackedEntity.equals(id);
    return this;
  }

  @override
  D2TrackedEntityAttributeValue? getByUid(String uid) {
    return box
        .query(D2TrackedEntityAttributeValue_.uid.equals(uid))
        .build()
        .findFirst();
  }

  @override
  D2TrackedEntityAttributeValue mapper(Map<String, dynamic> json) {
    return D2TrackedEntityAttributeValue.fromMap(db, json, "");
  }

  @override
  BaseDataRepository<D2TrackedEntityAttributeValue> setProgram(
      D2Program program) {
    this.program = program;
    return this;
  }
}
