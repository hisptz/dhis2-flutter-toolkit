import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';

class D2TrackerEnrollmentFormController extends D2FormController {
  D2Program program;
  D2ObjectBox db;
  D2Enrollment? enrollment;
  D2TrackedEntity? trackedEntity;
  D2OrgUnit? orgUnit;

  D2TrackerEnrollmentFormController(
      {required this.db,
      required this.program,
      D2Enrollment? enrollment,
      D2TrackedEntity? trackedEntity,
      super.mandatoryFields,
      super.hiddenFields,
      super.hiddenSections,
      this.orgUnit}) {
    if (enrollment != null) {
      this.enrollment = enrollment;
      Map<String, dynamic>? formValues = enrollment.toFormValues();
      setValues(formValues);
    }

    if (trackedEntity != null && enrollment == null) {
      this.trackedEntity = trackedEntity;

      ///Get the attributes from here

      List<D2TrackedEntityAttributeValue> attributes =
          trackedEntity.getAttributesByProgram(program);

      Map<String, dynamic> formValues = {};

      for (D2TrackedEntityAttributeValue element in attributes) {
        formValues.addAll(element.toFormValues());
      }

      setValues(formValues);
    }

    List<String> mandatoryFields = program.programTrackedEntityAttributes
        .where((pAttribute) => pAttribute.mandatory)
        .map((pAttribute) => pAttribute.trackedEntityAttribute.target!.uid)
        .toList();
    this.mandatoryFields.addAll(mandatoryFields);
  }

  ///Calls on submit and then saves the updated data. If the enrollment is new, a tracked entity is also created. It doesn't really need to be an async function
  Future<D2TrackedEntity> save() async {
    Map<String, dynamic> validatedFormValues = submit();

    D2OrgUnit? orgUnit = this.orgUnit ??
        D2OrgUnitRepository(db).getByUid(validatedFormValues["orgUnit"]);
    if (orgUnit == null) {
      throw "Could not get entity's organisation unit. You either have to pass it as a parameter when initializing the controller or have a required field with key 'orgUnit'";
    }
    D2TrackedEntity trackedEntity = D2TrackedEntity.fromFormValues(
        validatedFormValues,
        db: db,
        program: program,
        orgUnit: orgUnit);
    trackedEntity.save(db);
    return trackedEntity;
  }
}
