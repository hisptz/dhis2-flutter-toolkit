///Copyright (c) 2024, HISP Tanzania Developers.
///All rights reserved. Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.
library;

//
///`StringUtils` is a collection of custom helper functions for manipulating `String`
//
class D2StringUtils {
  //
  ///`StringUtils.escapeCharacter` is a method that escapes specified characters from a `String` to return a
  ///The method accepts a `String` to be sanitized and a list of `String` characters to be escaped as parameters, and returns a sanitized `String`
  /// ```dart
  /// String val = "Hello\n\"";
  /// val = StringUtils.escapeCharacter(val, escapeChar: ["\n", "\""]); ///this makes val = "Hello"
  ///```
  //
  static String escapeCharacter(
    String string, {
    List<String> escapeChar = const [],
  }) {
    for (String char in escapeChar) {
      string = string.replaceAll(char, '');
    }
    return string;
  }

  //
  ///`StringUtils.covertCamelCaseToSnakeCase`  is a method that converts a camelCase string into snake_case.
  /// The method accepts a `String` text parameter and returns back a snake_case conversion
  //
  static String covertCamelCaseToSnakeCase(String text) {
    RegExp expression = RegExp(r'(?<=[a-z])[A-Z]');
    return text
        .replaceAllMapped(expression, (Match match) => '_${match.group(0)}')
        .toLowerCase();
  }

  //
  ///`StringUtils.convertSnakeCaseToCamelCase` is a method that converts snake_case into a camelCase string
  /// The method accepts a `String` text parameter and returns the camelCase converted string
  //
  static String convertSnakeCaseToCamelCase(String text) {
    var sanitizedText = text.contains('_')
        ? text
            .split('_')
            .map((String str) =>
                "${str[0].toUpperCase()}${str.substring(1).toLowerCase()}")
            .toList()
            .join('')
        : text.replaceAll(RegExp(r"\s+"), '');

    return "${sanitizedText[0].toLowerCase()}${sanitizedText.substring(1)}";
  }

  //
  ///`StringUtils.escapeQuotes` is an helper function that escapes the string quotations on a string value
  /// The functions takes a `String` parameter and returns a sanitized `String` with no quotations.
  //
  static String escapeQuotes(String string) {
    String doubleQuotesPattern = '"';
    var singleQuotePosition = string.lastIndexOf("'").clamp(0, string.length);
    return string.contains(doubleQuotesPattern)
        ? string.replaceAll(doubleQuotesPattern, '')
        : string.startsWith("'") && string.endsWith("'")
            ? string
                .replaceFirst("'", "", singleQuotePosition)
                .replaceFirst("'", "", 0)
            : string;
  }
}
