import '../../../../models/data/enrollment.dart';
import '../../../../models/data/tracked_entity.dart';
import '../../../../models/data/tracked_entity_attribute_value.dart';
import '../../../../models/metadata/program.dart';
import '../form_state.dart';

class D2TrackerEnrollmentFormController extends D2FormController {
  D2Program program;
  D2Enrollment? enrollment;
  D2TrackedEntity? trackedEntity;

  D2TrackerEnrollmentFormController({
    required this.program,
    D2Enrollment? enrollment,
    D2TrackedEntity? trackedEntity,
    super.mandatoryFields,
    super.hiddenFields,
    super.hiddenSections,
  }) {
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

  ///Calls on submit and then saves the updated data. If the enrollment is new, a tracked entity is also created.
  Future<D2Enrollment> save() async {
    throw "Not implemented";
  }
}
