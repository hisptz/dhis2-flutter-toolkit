import 'dart:convert';

import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:flutter/material.dart';

class D2InputContainerColorScheme {
  Color error;
  Color main;
  Color text;
  Color active;
  Color inactive;
  Color disabled;

  D2InputContainerColorScheme.fromMainColor(this.main)
      : text = Colors.black,
        active = main,
        disabled = Colors.grey,
        error = Colors.red,
        inactive = const Color(0xFF94A0B1);

  D2InputContainerColorScheme(
      {required this.error,
      required this.main,
      required this.text,
      required this.active,
      required this.inactive,
      required this.disabled});

  @override
  String toString() {
    return jsonEncode({
      'active': active.toString(),
      'main': main.toString(),
      'text': text.toString(),
      'disabled': disabled.toString(),
      'error': error.toString()
    });
  }
}

class D2InputIconDecoration {
  final BoxConstraints iconConstraints;
  final Color backgroundColor;
  final Color? iconColor;
  final IconData? iconData;
  final String? svgIconAsset;

  D2InputIconDecoration(
      {required this.iconConstraints,
      required this.backgroundColor,
      this.iconColor,
      this.iconData,
      this.svgIconAsset});

  D2InputIconDecoration.fromInput(D2BaseInputFieldConfig input, {Color? color})
      : iconData = input.icon,
        svgIconAsset = input.svgIconAsset,
        iconColor = color,
        iconConstraints = const BoxConstraints(
          maxHeight: 45.0,
          minHeight: 42.0,
          maxWidth: 45.0,
          minWidth: 42.0,
        ),
        backgroundColor = color ?? Colors.transparent;

  @override
  String toString() {
    return jsonEncode({
      'icon': svgIconAsset ?? iconData.toString(),
      'backgroundColor': backgroundColor.toString(),
      'constraints': iconConstraints.toString()
    });
  }
}

class D2InputDecoration {
  final D2InputContainerColorScheme colorScheme;
  final D2InputIconDecoration inputIconDecoration;
  final BoxDecoration inputContainerDecoration;

  D2InputDecoration(
      {BoxDecoration? inputContainerDecoration,
      required this.inputIconDecoration,
      required this.colorScheme})
      : inputContainerDecoration = inputContainerDecoration ??
            BoxDecoration(
              color: colorScheme.main.withOpacity(0.07),
              border: Border(
                left: BorderSide.none,
                right: BorderSide.none,
                top: BorderSide.none,
                bottom: BorderSide(
                  width: 2,
                  color: colorScheme.main,
                ),
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4.0),
                topRight: Radius.circular(4.0),
              ),
            );

  D2InputDecoration.fromInput(D2BaseInputFieldConfig input,
      {required Color color, required bool disabled})
      : colorScheme = D2InputContainerColorScheme.fromMainColor(color),
        inputIconDecoration = D2InputIconDecoration.fromInput(input,
            color: disabled ? Colors.grey : color),
        inputContainerDecoration = BoxDecoration(
          color: disabled
              ? Colors.grey.withOpacity(0.07)
              : color.withOpacity(0.07),
          border: Border(
            left: BorderSide.none,
            right: BorderSide.none,
            top: BorderSide.none,
            bottom: BorderSide(
              width: 2,
              color: disabled ? Colors.grey : color,
            ),
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4.0),
            topRight: Radius.circular(4.0),
          ),
        );

  @override
  String toString() {
    Map details = {
      'colorScheme': colorScheme.toString(),
      'icon': inputIconDecoration.toString(),
      'container': inputContainerDecoration.toString()
    };

    return jsonEncode(details);
  }
}
