import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/state/tracker/program_rule_engine_state.dart';

import '../../../../models/metadata/program_rule.dart';
import '../field_state.dart';

class D2TrackerEventFormController extends D2FormController
    with ProgramRuleEngineState {
  D2ProgramStage programStage;
  D2Enrollment? enrollment;
  D2ObjectBox db;
  String? orgUnit;
  D2Event? event;
  late D2ProgramRuleEngine programRuleEngine;

  D2TrackerEventFormController(
      {required this.db,
      required this.programStage,
      this.event,
      this.enrollment,
      super.mandatoryFields,
      super.hiddenFields,
      super.hiddenSections,
      this.orgUnit}) {
    if (event != null) {
      Map<String, dynamic> formValues = event!.toFormValues();
      setValues(formValues);
    }

    if (programStage.program.target!.programType == "WITH_REGISTRATION" &&
        enrollment == null) {
      throw "Enrollment is required for tracker programs";
    }
    List<String> mandatoryFields = programStage.programStageDataElements
        .where((pDataElement) => pDataElement.compulsory)
        .map((pDataElement) => pDataElement.dataElement.target!.uid)
        .toList();
    this.mandatoryFields.addAll(mandatoryFields);
    initializeProgramRuleEngine(programStage.program.target!);
  }

  void initializeProgramRuleEngine(D2Program program) {
    List<D2ProgramRule> programRules = program.programRules;
    List<D2ProgramRuleVariable> programRuleVariables =
        program.programRuleVariables;
    programRuleEngine = D2ProgramRuleEngine(
      programRules: programRules,
      programRuleVariables: programRuleVariables,
      trackedEntity: event?.trackedEntity.target,
    );

    for (var section in programStage.programStageSections) {
      for (var attribute in section.programStageSectionDataElements) {
        spawnProgramRuleEngine(
          programRuleEngine,
          attribute.dataElement.target?.uid ?? "",
        );
      }
    }
  }

  Future<D2Event> create() async {
    Map<String, dynamic> validatedFormValues = submit();
    D2OrgUnit? orgUnit = D2OrgUnitRepository(db)
        .getByUid(this.orgUnit ?? validatedFormValues["orgUnit"]);
    if (orgUnit == null) {
      throw "Could not get entity's organisation unit. You either have to pass it as a parameter when initializing the controller or have a required field with key 'orgUnit'";
    }

    D2Event newEvent = D2Event.fromFormValues(validatedFormValues,
        db: db,
        programStage: programStage,
        orgUnit: orgUnit,
        enrollment: enrollment);

    newEvent.save(db);

    return newEvent;
  }

  // TODO find means to make this reusable
  @override
  FieldState getFieldState(String key) {
    void onChange(value) {
      setValue(key, value);
      spawnProgramRuleEngine(programRuleEngine, key);
    }

    bool hidden = isFieldHidden(key);
    bool disabled = isFieldDisabled(key);
    bool mandatory = isFieldMandatory(key);
    dynamic value = getValue(key);
    String? error = getError(key);
    String? warning = getWarning(key);
    return FieldState(
        onChange: onChange,
        hidden: hidden,
        value: value,
        disabled: disabled,
        warning: warning,
        mandatory: mandatory,
        error: error);
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

  ///Calls on submit and then saves the updated data. It doesn't really need to be an async function but is set as one for forward compatibility
  Future<D2Event> save() async {
    if (event != null) {
      return update();
    } else {
      return create();
    }
  }
}
