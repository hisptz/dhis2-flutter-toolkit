import 'dart:async';
import 'dart:convert';
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:flutter/material.dart';

class D2TrackerEventForm extends StatefulWidget {
  final D2TrackerEventFormController controller;
  final D2ProgramStage programStage;
  final D2TrackerFormOptions options;
  final Function? onCheckAutoSavedValue;
  final Color? color;
  final bool disabled;
  final bool disableAutoSave;

  final String? autoSaveMessage;

  const D2TrackerEventForm(
      {super.key,
      required this.controller,
      required this.programStage,
      required this.options,
      this.onCheckAutoSavedValue,
      this.color,
      this.disabled = false,
      this.disableAutoSave = false,
      this.autoSaveMessage});

  @override
  State<D2TrackerEventForm> createState() => _D2TrackerEventFormState();
}

class _D2TrackerEventFormState extends State<D2TrackerEventForm> {
  late bool hasAutoSavedValue;
  Timer? _autoSaveTimer;

  @override
  void initState() {
    hasAutoSavedValue = checkAutoSavedValue();
    widget.controller.addListener(_startAutoSaveTimer);

    super.initState();
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    super.dispose();
  }

  void _startAutoSaveTimer() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer =
        (widget.disableAutoSave || widget.onCheckAutoSavedValue == null)
            ? null
            : Timer(const Duration(seconds: 1), _performAutoSave);
  }

  Future<void> _performAutoSave() async {
    try {
      final d2geometryValue = widget.controller.getValue('geometry');
      widget.controller
          .setValueSilently('geometry', d2geometryValue?.toGeoJson());

      Map<String, dynamic>? formValues = widget.controller.formValues;

      formValues.removeWhere((key, value) {
        if (value == null) {
          return true;
        } else if (value is String && (value.isEmpty || value == 'null')) {
          return true;
        }
        return false;
      });

      String autoSavedValues = json.encode(formValues);

      widget.controller.setValueSilently('geometry', d2geometryValue);

      D2AppAutoSaveRepository d2appAutoSaveRepository =
          D2AppAutoSaveRepository(widget.controller.db);

      List<Map<String, dynamic>> autoSaveData = [
        {
          'id': '',
          'data': autoSavedValues,
          'programStage': widget.controller.programStage,
          'event': widget.controller.event,
        }
      ];

      autoSavedValues != '{}'
          ? d2appAutoSaveRepository.saveOffline(autoSaveData)
          : null;
    } catch (e) {
      throw 'Auto-save failed: $e';
    }
  }

  bool checkAutoSavedValue() {
    D2AppAutoSaveRepository d2appAutoSaveRepository =
        D2AppAutoSaveRepository(widget.controller.db);

    List<D2AppAutoSave>? eventAutoSavedValue = widget.controller.event == null
        ? d2appAutoSaveRepository
            .getByProgramStage(widget.controller.programStage)
        : d2appAutoSaveRepository.getByEvent(widget.controller.event!);

    return eventAutoSavedValue?.isNotEmpty ?? false;
  }

  void onDeleteAutoSavedData() {
    D2AppAutoSaveRepository d2appAutoSaveRepository =
        D2AppAutoSaveRepository(widget.controller.db);

    List<D2AppAutoSave>? eventAutoSavedValue = widget.controller.event == null
        ? d2appAutoSaveRepository
            .getByProgramStage(widget.controller.programStage)
        : d2appAutoSaveRepository.getByEvent(widget.controller.event!);

    if (eventAutoSavedValue != null) {
      d2appAutoSaveRepository.deleteEntities(eventAutoSavedValue);

      hasAutoSavedValue = checkAutoSavedValue();
    }
    widget.onCheckAutoSavedValue != null
        ? widget.onCheckAutoSavedValue!(hasAutoSavedValue)
        : null;
  }

  void onContinue() {
    D2AppAutoSaveRepository d2appAutoSaveRepository =
        D2AppAutoSaveRepository(widget.controller.db);

    List<D2AppAutoSave>? eventAutoSavedValue = widget.controller.event == null
        ? d2appAutoSaveRepository
            .getByProgramStage(widget.controller.programStage)
        : d2appAutoSaveRepository.getByEvent(widget.controller.event!);

    Map<String, dynamic> autoSavedValues =
        json.decode(eventAutoSavedValue?.firstOrNull?.data ?? "");

    if (autoSavedValues["geometry"] != null) {
      D2GeometryValue d2geometryValue =
          D2GeometryValue.fromGeoJson(autoSavedValues["geometry"]);
      autoSavedValues["geometry"] = d2geometryValue;
    }

    if (autoSavedValues["householdMembers"] != null) {
      List<dynamic> tempList = autoSavedValues["householdMembers"];
      List<String>? householdMembers =
          tempList.map((member) => member.toString()).toList();

      autoSavedValues["householdMembers"] = householdMembers;
    }

    widget.controller.setValues(autoSavedValues);

    hasAutoSavedValue = false;

    widget.onCheckAutoSavedValue != null
        ? widget.onCheckAutoSavedValue!(hasAutoSavedValue)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    List<D2FormSection> formSections = [
      ...widget.options.formSections,
      ...D2TrackerEventFormUtil(
              programStage: widget.programStage,
              options: widget.options,
              db: widget.controller.db)
          .formSections,
    ];

    Color formColor = widget.color ?? Theme.of(context).primaryColor;

    if (!widget.disableAutoSave &&
        hasAutoSavedValue &&
        widget.onCheckAutoSavedValue != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
              child: Text(
            widget.autoSaveMessage ??
                'Would you like to continue with the auto-saved data available?',
            textAlign: TextAlign.center,
          )),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: FilledButton(
                    style: const ButtonStyle().copyWith(
                      backgroundColor:
                          WidgetStateProperty.all(Colors.transparent),
                      foregroundColor: WidgetStatePropertyAll(Colors.grey[600]),
                      textStyle: WidgetStateProperty.all(
                        const TextStyle().copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onPressed: onDeleteAutoSavedData,
                    child: Container(
                      alignment: Alignment.center,
                      width: 30.0,
                      child: Text(
                        'Skip',
                        style: const TextStyle().copyWith(),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: FilledButton(
                    style: const ButtonStyle().copyWith(
                      backgroundColor: WidgetStateProperty.all(formColor),
                      foregroundColor:
                          const WidgetStatePropertyAll(Colors.white),
                      textStyle: WidgetStateProperty.all(
                        const TextStyle().copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onPressed: onContinue,
                    child: Container(
                      alignment: Alignment.center,
                      width: 60.0,
                      child: Text(
                        'Continue',
                        style: const TextStyle().copyWith(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return D2ControlledForm(
        color: formColor,
        disabled: widget.disabled,
        form: D2Form(
            title: widget.options.showTitle
                ? widget.programStage.displayName ?? widget.programStage.name
                : null,
            sections: formSections),
        controller: widget.controller);
  }
}
