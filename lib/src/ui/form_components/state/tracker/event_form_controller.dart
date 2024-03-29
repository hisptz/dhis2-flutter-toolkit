import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';

class D2TrackerEventFormController extends D2FormController {
  D2ProgramStage programStage;
  D2ObjectBox db;
  String? orgUnit;
  D2Event? event;

  D2TrackerEventFormController(
      {required this.db,
      required this.programStage,
      this.event,
      super.mandatoryFields,
      super.hiddenFields,
      super.hiddenSections,
      this.orgUnit}) {
    if (event != null) {
      Map<String, dynamic> formValues = event!.toFormValues();
      setValues(formValues);
    }
    List<String> mandatoryFields = programStage.programStageDataElements
        .where((pDataElement) => pDataElement.compulsory)
        .map((pDataElement) => pDataElement.dataElement.target!.uid)
        .toList();
    this.mandatoryFields.addAll(mandatoryFields);
  }

  Future<D2Event> create() async {
    Map<String, dynamic> validatedFormValues = submit();
    D2OrgUnit? orgUnit = D2OrgUnitRepository(db)
        .getByUid(this.orgUnit ?? validatedFormValues["orgUnit"]);
    if (orgUnit == null) {
      throw "Could not get entity's organisation unit. You either have to pass it as a parameter when initializing the controller or have a required field with key 'orgUnit'";
    }

    D2Event newEvent = D2Event.fromFormValues(validatedFormValues,
        db: db, programStage: programStage, orgUnit: orgUnit);
    newEvent.save(db);

    return newEvent;
  }

  Future<D2Event> update() async {
    if (event == null) {
      throw "Invalid update call. Only call update if a default event has been passed as a parameter when initializing the controller";
    }
    Map<String, dynamic> validatedFormValues = submit();
    D2OrgUnit? orgUnit = D2OrgUnitRepository(db)
        .getByUid(this.orgUnit ?? validatedFormValues["orgUnit"]);
    event!.updateFromFormValues(validatedFormValues, db: db, orgUnit: orgUnit);
    event!.save(db);
    return event!;
  }

  ///Calls on submit and then saves the updated data. If the enrollment is new, a tracked entity is also created. It doesn't really need to be an async function
  Future<D2Event> save() async {
    if (event != null) {
      return update();
    } else {
      return create();
    }
  }
}
