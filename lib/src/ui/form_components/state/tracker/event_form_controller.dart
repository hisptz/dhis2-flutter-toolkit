import '../../../../../objectbox.dart';
import '../../../../models/data/entry.dart';
import '../../../../models/metadata/entry.dart';
import '../../../../models/metadata/program_rule.dart';
import '../../../../repositories/metadata/entry.dart';
import '../../../../utils/program_rule_engine/program_rule_engine.dart';
import '../form_state.dart';
import 'program_rule_engine_state.dart';

/// This is a controller class for managing a form related to tracker events.
class D2TrackerEventFormController extends D2FormController
    with ProgramRuleEngineState {
  /// Program stage associated with the form.
  final D2ProgramStage programStage;

  /// Optional enrollment associated with the event.
  final D2Enrollment? enrollment;

  @override
  D2ObjectBox db;

  /// Optional organization unit UID associated with the event.
  String? orgUnit;

  /// Optional event managed by this controller.
  D2Event? event;

  @override
  late D2ProgramRuleEngine programRuleEngine;

  /// Constructs a new [D2TrackerEventFormController].
  ///
  /// - [db] Database instance used for data operations.
  /// - [programStage] Program stage associated with the form.
  /// - [event] Optional event to initialize the form with.
  /// - [enrollment] Optional enrollment associated with the event.
  /// - [orgUnit] Optional organization unit UID associated with the event.
  D2TrackerEventFormController(
      {required this.db,
      required this.programStage,
      this.event,
      this.enrollment,
      super.mandatoryFields,
      super.hiddenFields,
      super.hiddenSections,
      super.disabledFields,
      super.initialValues,
      super.formFields,
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

  /// Initializes the program rule engine with program rules and variables.
  ///
  /// - [program] Program associated with the form.
  void initializeProgramRuleEngine(D2Program program) {
    List<D2ProgramRule> programRules = program.programRules;
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

  /// Creates a new event based on form submission.
  ///
  /// Returns the created [D2Event] instance.
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

  /// Updates the existing event based on form submission.
  ///
  /// Returns the updated [D2Event] instance.
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

  /// Calls submit and then saves the updated data.
  ///
  ///Calls on submit and then saves the updated data. It doesn't really need to be an async function but is set as one for forward compatibility
  ///
  /// Returns the saved [D2Event] instance.
  Future<D2Event> save() async {
    if (event != null) {
      return update();
    } else {
      return create();
    }
  }
}
