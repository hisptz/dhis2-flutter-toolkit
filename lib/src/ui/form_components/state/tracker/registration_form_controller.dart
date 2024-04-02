import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:flutter/foundation.dart';

class D2TrackerEnrollmentFormController extends D2FormController {
  D2Program program;
  D2ObjectBox db;
  D2Enrollment? enrollment;
  D2TrackedEntity? trackedEntity;
  String? orgUnit;

  D2TrackerEnrollmentFormController(
      {required this.db,
      required this.program,
      D2TrackedEntity? trackedEntity,
      super.mandatoryFields,
      super.hiddenFields,
      super.hiddenSections,
      this.orgUnit}) {
    if (trackedEntity != null) {
      this.trackedEntity = trackedEntity;

      ///Get the attributes from here
      List<D2TrackedEntityAttributeValue> attributes =
          trackedEntity.getAttributesByProgram(program);
      Map<String, dynamic> formValues = {};

      for (D2TrackedEntityAttributeValue element in attributes) {
        formValues.addAll(element.toFormValues());
      }
      //Get the enrollment from here
      D2Enrollment? enrollment = trackedEntity.enrollments.firstWhereOrNull(
          (element) =>
              element.program.targetId == program.id &&
              element.status == "ACTIVE");
      if (enrollment == null) {
        if (kDebugMode) {
          print(
              "The selected tracked entity does not have an active enrollment in this program. A new enrollment will be created instead");
        }
      } else {
        Map<String, dynamic> enrollmentFormValues = enrollment.toFormValues();
        formValues.addAll(enrollmentFormValues);
        this.enrollment = enrollment;
      }
      setValues(formValues);
    }

    List<String> mandatoryFields = program.programTrackedEntityAttributes
        .where((pAttribute) => pAttribute.mandatory)
        .map((pAttribute) => pAttribute.trackedEntityAttribute.target!.uid)
        .toList();
    this.mandatoryFields.addAll(mandatoryFields);
  }

  Future<D2TrackedEntity> create() async {
    Map<String, dynamic> validatedFormValues = submit();
    D2OrgUnit? orgUnit = D2OrgUnitRepository(db)
        .getByUid(this.orgUnit ?? validatedFormValues["orgUnit"]);
    if (orgUnit == null) {
      throw "Could not get entity's organisation unit. You either have to pass it as a parameter when initializing the controller or have a required field with key 'orgUnit'";
    }
    D2TrackedEntity trackedEntity = D2TrackedEntity.fromFormValues(
        validatedFormValues,
        db: db,
        program: program,
        orgUnit: orgUnit);

    if (validatedFormValues["geometry"] != null) {
      var geometryValue = validatedFormValues["geometry"];

      ///A form has geometry. This should be inserted as a serialized JSON
      if (geometryValue is D2GeometryValue) {
        Map<String, dynamic> geometry = geometryValue.toGeoJson();
        trackedEntity.geometry = jsonEncode(geometry);
      }
    }
    trackedEntity.save(db);
    return trackedEntity;
  }

  Future<D2TrackedEntity> update() async {
    if (trackedEntity == null) {
      throw "Invalid update call. Only call update if a default trackedEntity has been passed as a parameter when initializing the controller";
    }
    Map<String, dynamic> validatedFormValues = submit();
    D2OrgUnit? orgUnit = D2OrgUnitRepository(db)
        .getByUid(this.orgUnit ?? validatedFormValues["orgUnit"]);
    trackedEntity!.updateFromFormValues(validatedFormValues, db: db);

    if (validatedFormValues["geometry"] != null) {
      var geometryValue = validatedFormValues["geometry"];

      ///A form has geometry. This should be inserted as a serialized JSON
      if (geometryValue is D2GeometryValue) {
        Map<String, dynamic> geometry = geometryValue.toGeoJson();
        trackedEntity!.geometry = jsonEncode(geometry);
      }
    }

    if (enrollment != null) {
      enrollment!.updateFromFormValues(validatedFormValues, db: db);
      enrollment!.save(db);
    } else {
      if (orgUnit == null) {
        throw "Could not get entity's organisation unit. You either have to pass it as a parameter when initializing the controller or have a required field with key 'orgUnit'";
      }
      D2Enrollment enrollment = D2Enrollment.fromFormValues(validatedFormValues,
          db: db,
          trackedEntity: trackedEntity!,
          program: program,
          orgUnit: orgUnit);
      trackedEntity!.enrollments.add(enrollment);
    }
    trackedEntity!.save(db);
    return trackedEntity!;
  }

  ///Calls on submit and then saves the updated data. If the enrollment is new, a tracked entity is also created. It doesn't really need to be an async function
  Future<D2TrackedEntity> save() async {
    if (trackedEntity != null) {
      return update();
    } else {
      return create();
    }
  }
}
