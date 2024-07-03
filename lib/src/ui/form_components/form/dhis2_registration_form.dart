import 'dart:async';

import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class D2TrackerRegistrationForm extends StatefulWidget {
  final D2TrackerEnrollmentFormController controller;
  final D2Program program;
  final D2TrackerFormOptions options;
  final Color? color;
  final Function onCheckAutoSavedValue;
  final bool disabled;
  final bool disableAutoSave;

  const D2TrackerRegistrationForm(
      {super.key,
      required this.controller,
      required this.program,
      required this.options,
      this.color,
      this.disabled = false,
      required this.onCheckAutoSavedValue,
      this.disableAutoSave = false});

  @override
  State<D2TrackerRegistrationForm> createState() =>
      _D2TrackerRegistrationFormState();
}

class _D2TrackerRegistrationFormState extends State<D2TrackerRegistrationForm> {
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
        ((widget.controller.enrollment != null) || (widget.disableAutoSave))
            ? null
            : Timer(const Duration(seconds: 1), _performAutoSave);
  }

  Future<void> _performAutoSave() async {
    try {
      final d2geometryValue = widget.controller.getValue('geometry');
      widget.controller
          .setValueSilently('geometry', d2geometryValue?.toGeoJson());

      Map<String, dynamic>? formValues = widget.controller.formValues;

      formValues?.removeWhere((key, value) {
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
          'program': widget.controller.program,
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

    List<D2AppAutoSave>? programAutoSavedValue =
        d2appAutoSaveRepository.getByProgram(widget.controller.program);

    return widget.controller.enrollment == null
        ? programAutoSavedValue?.isNotEmpty ?? false
        : false;
  }

  void onDeleteAutoSavedData() {
    D2AppAutoSaveRepository d2appAutoSaveRepository =
        D2AppAutoSaveRepository(widget.controller.db);

    List<D2AppAutoSave>? programAutoSavedValue =
        d2appAutoSaveRepository.getByProgram(widget.controller.program);

    if (programAutoSavedValue != null) {
      d2appAutoSaveRepository.deleteEntities(programAutoSavedValue);
      setState(() {
        hasAutoSavedValue = checkAutoSavedValue();
      });
    }
    widget.onCheckAutoSavedValue(hasAutoSavedValue);
  }

  void onContinue() {
    D2AppAutoSaveRepository d2appAutoSaveRepository =
        D2AppAutoSaveRepository(widget.controller.db);

    List<D2AppAutoSave>? programAutoSavedValue =
        d2appAutoSaveRepository.getByProgram(widget.controller.program);

    Map<String, dynamic> autoSavedValues =
        json.decode(programAutoSavedValue?.firstOrNull?.data ?? "");

    if (autoSavedValues["geometry"] != null) {
      D2GeometryValue d2geometryValue =
          D2GeometryValue.fromGeoJson(autoSavedValues["geometry"]);
      autoSavedValues["geometry"] = d2geometryValue;
    }

    widget.controller.setValues(autoSavedValues);
    onDeleteAutoSavedData();
  }

  @override
  Widget build(BuildContext context) {
    List<D2FormSection> formSections = D2TrackerEnrollmentFormUtil(
            program: widget.program,
            options: widget.options,
            db: widget.controller.db)
        .formSections;
    Color formColor = widget.color ?? Theme.of(context).primaryColor;

    if (!widget.disableAutoSave && hasAutoSavedValue) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
              child: Text(
            'Would you like to continue with the auto-saved data available?',
            textAlign: TextAlign.center,
          )),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: FilledButton(
                    style: const ButtonStyle().copyWith(
                      backgroundColor:
                          WidgetStateProperty.all(Colors.transparent),
                      foregroundColor: WidgetStatePropertyAll(Colors.red[400]),
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
                      width: 70.0,
                      child: Text(
                        'Cancel',
                        style: const TextStyle().copyWith(),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: FilledButton(
                    style: const ButtonStyle().copyWith(
                      backgroundColor:
                          WidgetStateProperty.all(Colors.green[600]),
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
                      width: 70.0,
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
        disabled: widget.disabled,
        color: formColor,
        form: D2Form(
            title: widget.options.showTitle
                ? widget.program.displayName ?? widget.program.shortName
                : null,
            sections: [...widget.options.formSections, ...formSections]),
        controller: widget.controller);
  }
}
