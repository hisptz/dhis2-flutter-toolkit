import '../../../../../objectbox.dart';
import '../../../../models/data/entry.dart';
import '../../../../models/metadata/entry.dart';
import '../../../../models/metadata/program_rule.dart';
import '../../../../repositories/metadata/entry.dart';
import '../../../../utils/program_rule_engine/models/custom_program_rule.dart';
import '../../../../utils/program_rule_engine/program_rule_engine.dart';
import '../form_state.dart';
import 'program_rule_engine_state.dart';

class D2TrackerEventFormController extends D2FormController
    with ProgramRuleEngineState {
  D2ProgramStage programStage;
  D2Enrollment? enrollment;
  @override
  D2ObjectBox db;
  String? orgUnit;
  D2Event? event;
  @override
  List<D2CustomProgramRule> customProgramRules;
  @override
  late D2ProgramRuleEngine programRuleEngine;

  D2TrackerEventFormController(
      {required this.db,
      required this.programStage,
      this.event,
      this.enrollment,
      this.customProgramRules = const [],
      super.mandatoryFields,
      super.hiddenFields,
      super.hiddenSections,
      super.disabledFields,
      super.initialValues,
      super.formFields,
      this.orgUnit}) {
    if (event != null) {
      if (event!.programStage.targetId != programStage.id) {
        throw "Invalid program stage ${programStage.name} passed for an event from the program stage ${event!.programStage.target?.name}";
      }
      setEvent(event!);
    }

    List<String> mandatoryFields = programStage.programStageDataElements
        .where((pDataElement) => pDataElement.compulsory)
        .map((pDataElement) => pDataElement.dataElement.target!.uid)
        .toList();
    this.mandatoryFields.addAll(mandatoryFields);
    initializeProgramRuleEngine(programStage.program.target!);
  }

  void setEvent(D2Event event) {
    Map<String, dynamic> formValues = event.toFormValues();
    setValues(formValues);
    this.event = event;
  }

  void initializeProgramRuleEngine(D2Program program) {
    List<D2ProgramRule> programRules = program.programRules
        .where((rule) =>
            rule.programStage.targetId == 0 ||
            rule.programStage.targetId == programStage.id)
        .toList();
    List<D2ProgramRuleVariable> programRuleVariables =
        program.programRuleVariables;
    programRuleEngine = D2ProgramRuleEngine(
      programRules: programRules,
      programRuleVariables: programRuleVariables,
      trackedEntity: event != null
          ? event!.trackedEntity.target
          : enrollment?.trackedEntity.target,
    );
    runProgramRules();
  }

  Future<D2Event> create() async {
    Map<String, dynamic> validatedFormValues = submit();
    D2OrgUnit? orgUnit = enrollment?.orgUnit.target;
    if (this.orgUnit != null || validatedFormValues["orgUnit"] != null) {
      orgUnit = D2OrgUnitRepository(db)
          .getByUid(this.orgUnit ?? validatedFormValues["orgUnit"]);
    }
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
