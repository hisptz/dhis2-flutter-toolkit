import 'dart:async';
import 'dart:convert';

import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/ui/form_components/form/auto_save_message_container.dart';
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
      return AutoSaveMessageContainer(
        formColor: formColor,
        autoSaveMessage: widget.autoSaveMessage,
        onDeleteAutoSavedData: onDeleteAutoSavedData,
        onContinue: onContinue,
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
