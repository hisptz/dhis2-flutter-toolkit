import 'dart:convert';

import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:flutter/material.dart';

/// This class represents the color scheme for an input container.
class D2InputContainerColorScheme {
  /// The color used for error states.
  Color error;

  /// The main color used in the color scheme.
  Color main;

  /// The color used for text.
  Color text;

  /// The color used for active states.
  Color active;

  /// The color used for inactive states.
  Color inactive;

  /// The color used for disabled states.
  Color disabled;

  /// The color used for warning states.
  Color warning;

  /// Creates a color scheme from a main color.
  ///
  /// - [main] The main color.
  D2InputContainerColorScheme.fromMainColor(this.main)
      : text = Colors.black,
        active = main,
        disabled = Colors.grey,
        error = Colors.red,
        warning = Colors.orangeAccent,
        inactive = const Color(0xFF94A0B1);

  /// Creates a color scheme with specified colors.
  ///
  /// - [error] The color for error states.
  /// - [warning] The color for warning states.
  /// - [main] The main color.
  /// - [text] The color for text.
  /// - [active] The color for active states.
  /// - [inactive] The color for inactive states.
  /// - [disabled] The color for disabled states.
  D2InputContainerColorScheme(
      {required this.error,
      required this.warning,
      required this.main,
      required this.text,
      required this.active,
      required this.inactive,
      required this.disabled});

  /// Gets the status color based on the current state.
  ///
  /// - [hasError] Indicates if there is an error.
  /// - [isDisabled] Indicates if the field is disabled.
  /// - [hasWarning] Indicates if there is a warning.
  /// - Returns the appropriate color based on the state.
  Color getStatusColor(
      {bool hasError = false,
      bool isDisabled = false,
      bool hasWarning = false}) {
    if (hasError) {
      return error;
    }
    if (hasWarning) {
      return warning;
    }
    if (isDisabled) {
      return disabled;
    }

    return main;
  }

  /// Converts the color scheme to a JSON string representation.
  ///
  /// - Returns a JSON string representation of the color scheme.
  @override
  String toString() {
    return jsonEncode({
      'active': active.toString(),
      'main': main.toString(),
      'text': text.toString(),
      'disabled': disabled.toString(),
      'error': error.toString(),
      'warning': warning.toString()
    });
  }
}

/// This class represents decoration configuration for input icons.
class D2InputIconDecoration {
  /// Constraints for the icon size.
  final BoxConstraints iconConstraints;

  /// Background color of the icon.
  final Color backgroundColor;

  /// Color of the icon.
  final Color? iconColor;

  /// Data for the icon.
  final IconData? iconData;

  /// Asset path for an SVG icon.
  final String? svgIconAsset;

  /// Constructs an input icon decoration with the provided parameters.
  ///
  /// - [iconConstraints] Constraints for the icon size.
  /// - [backgroundColor] Background color of the icon.
  /// - [iconColor] Color of the icon.
  /// - [iconData] Data for the icon.
  /// - [svgIconAsset] Asset path for an SVG icon.
  D2InputIconDecoration(
      {required this.iconConstraints,
      required this.backgroundColor,
      this.iconColor,
      this.iconData,
      this.svgIconAsset});

  /// Constructs an input icon decoration from an input field configuration.
  ///
  /// - [input] The input field configuration.
  /// - [color] The color for the icon.
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

  /// Converts the icon decoration to a JSON string representation.
  ///
  /// - Returns a JSON string representation of the icon decoration.
  @override
  String toString() {
    return jsonEncode({
      'icon': svgIconAsset ?? iconData.toString(),
      'backgroundColor': backgroundColor.toString(),
      'constraints': iconConstraints.toString()
    });
  }
}

/// This class represents decoration configuration for input containers.
class D2InputDecoration {
  /// The color scheme for the input container.
  final D2InputContainerColorScheme colorScheme;

  /// Decoration configuration for the input icon.
  late final D2InputIconDecoration inputIconDecoration;

  /// Decoration for the input container.
  late final BoxDecoration inputContainerDecoration;

  /// Constructs an input decoration with the provided parameters.
  ///
  /// - [inputContainerDecoration] Decoration for the input container.
  /// - [inputIconDecoration] Decoration configuration for the input icon.
  /// - [colorScheme] The color scheme for the input container.
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

  /// Constructs an input decoration from an input field configuration.
  ///
  /// - [input] The input field configuration.
  /// - [color] The color for the input container.
  /// - [disabled] Indicates if the input is disabled.
  /// - [error] Indicates if the input has an error.
  /// - [warning] Indicates if the input has a warning.
  D2InputDecoration.fromInput(D2BaseInputFieldConfig input,
      {required Color color,
      required bool disabled,
      required bool error,
      required bool warning})
      : colorScheme = D2InputContainerColorScheme.fromMainColor(color) {
    Color color = colorScheme.getStatusColor(
        isDisabled: disabled, hasError: error, hasWarning: warning);

    inputIconDecoration = D2InputIconDecoration.fromInput(input, color: color);
    inputContainerDecoration = BoxDecoration(
      color: color.withOpacity(0.07),
      border: Border(
        left: BorderSide.none,
        right: BorderSide.none,
        top: BorderSide.none,
        bottom: BorderSide(width: 2, color: color),
      ),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(4.0),
        topRight: Radius.circular(4.0),
      ),
    );
  }

  /// Converts the input decoration to a JSON string representation.
  ///
  /// - Returns a JSON string representation of the input decoration.
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
