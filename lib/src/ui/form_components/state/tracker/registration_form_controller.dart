import '../../../../models/data/enrollment.dart';
import '../../../../models/metadata/program.dart';
import '../form_state.dart';

class D2TrackerRegistrationFormController extends D2FormController {
  D2Program program;

  D2TrackerRegistrationFormController({
    required this.program,
    D2Enrollment? enrollment,
    super.hiddenFields,
    super.hiddenSections,
  }) {
    if (enrollment != null) {
      Map<String, dynamic>? formValues = enrollment.toFormValues();
      setValues(formValues);
    }
    List<String> mandatoryFields = program.programTrackedEntityAttributes
        .where((pAttribute) => pAttribute.mandatory)
        .map((pAttribute) => pAttribute.trackedEntityAttribute.target!.uid)
        .toList();
    this.mandatoryFields = mandatoryFields;
  }
}
