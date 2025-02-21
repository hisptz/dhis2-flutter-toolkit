import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';
import 'base_input.dart';
import 'input_field_icon.dart';
import 'package:permission_handler/permission_handler.dart';

class BarCodeScannerInput
    extends BaseStatefulInput<D2BaseInputFieldConfig, String> {
  const BarCodeScannerInput(
      {super.key,
      super.disabled,
      required super.input,
      required super.onChange,
      required super.color,
      this.onScan,
      super.value,
      this.isTapToScanEnabled = false,
      this.inputFormatters = const [],
      required super.decoration});

  final List<TextInputFormatter> inputFormatters;
  final bool isTapToScanEnabled;
  final void Function(String)? onScan;

  @override
  State<StatefulWidget> createState() {
    return BarCodeScannerInputState();
  }
}

class BarCodeScannerInputState
    extends BaseStatefulInputState<BarCodeScannerInput> {
  late TextEditingController controller;
  List<TextInputFormatter> inputFormatters = [];

  @override
  void initState() {
    controller = TextEditingController(text: widget.value);
    String? fieldMask = widget.input.fieldMask;
    inputFormatters.addAll(widget.inputFormatters);
    if (fieldMask != null) {
      inputFormatters.add(FilteringTextInputFormatter.allow(RegExp(fieldMask)));
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BarCodeScannerInput oldWidget) {
    if (widget.value == null) {
      controller = TextEditingController();
    } else if (widget.value != controller.text) {
      controller.text = widget.value ?? '';
    }
    super.didUpdateWidget(oldWidget);
  }

  Future<void> onOpenBarCodeScanner(BuildContext context,
      {bool fromIcon = false}) async {
    if (widget.disabled) return;

    PermissionStatus status = await Permission.camera.status;

    if (status.isGranted) {
      _startBarcodeScan(context);
    } else if (status.isDenied) {
      PermissionStatus permissionStatus = await Permission.camera.request();

      if (permissionStatus.isGranted) {
        _startBarcodeScan(
          context,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
            'Camera permission is required to scan barcodes.',
            style: TextStyle(color: Colors.white),
          )),
        );
      }
    }
  }

  Future<void> _startBarcodeScan(
    BuildContext context,
  ) async {
    try {
      var result = await BarcodeScanner.scan();
      if (result.type == ResultType.Barcode) {
        widget.onScan != null ? widget.onScan!(result.rawContent) : null;
        controller.text = result.rawContent;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
          'Error scanning barcode',
          style: TextStyle(color: Colors.white),
        )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        enabled: !widget.disabled,
        cursorColor: widget.decoration.colorScheme.active,
        controller: controller,
        onChanged: (String? value) {
          widget.onChange(value);
        },
        keyboardType: TextInputType.number,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: IconButton(
              color: widget.color,
              padding: EdgeInsets.zero,
              constraints: iconConstraints,
              onPressed: widget.disabled
                  ? null
                  : () {
                      onOpenBarCodeScanner(context);
                    },
              icon: InputFieldIcon(
                  backgroundColor: widget.color,
                  iconColor: widget.color,
                  iconData: Icons.document_scanner_outlined),
            )),
        onTap: widget.disabled
            ? null
            : () {
                if (widget.isTapToScanEnabled) {
                  onOpenBarCodeScanner(context);
                }
              });
  }
}
