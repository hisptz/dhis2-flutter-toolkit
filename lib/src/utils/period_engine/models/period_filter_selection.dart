/// Copyright (c) 2024, HISP Tanzania Developers.
/// All rights reserved. Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.

library;

import 'package:dhis2_flutter_toolkit/src/utils/period_engine/constants/period_categories.dart';

import 'period.dart';
import 'period_type.dart';

/// This class represents a period selection with various attributes and utility methods.
class D2PeriodSelection {
  /// The category of the period selection.
  late String category;

  /// The type of the period selection.
  String? type;

  /// List of selected period IDs.
  List<String>? selected = [];

  /// Start date of the period.
  DateTime? start;

  /// End date of the period.
  DateTime? end;

  /// Display name for the period selection.
  String? displayName;

  /// Constructs a [D2PeriodSelection].
  ///
  /// - [category]: The category of the period selection.
  /// - [type]: The type of the period selection.
  /// - [selected]: List of selected period IDs.
  /// - [start]: Start date of the period.
  /// - [end]: End date of the period.
  D2PeriodSelection(
      {required this.category, this.type, this.selected, this.start, this.end});

  /// Override toString method to customize string representation of the object
  /// Returns the string representation of the object.
  @override
  String toString() {
    return "$category ${type ?? ''}";
  }

  /// Converts camelCase to snake_case.
  ///
  /// - [value]: The camelCase string.
  /// - [separator]: The separator to use (default is '_').
  ///
  /// Returns the snake_case version of the input string.
  String uncamelize(String value, {String separator = '_'}) {
    return value.replaceAllMapped(RegExp(r'[A-Z]|\d+'), (match) {
      return '$separator${match[0]}';
    }).toUpperCase();
  }

  /// Creates a [D2PeriodSelection] object from a list of selection IDs.
  ///
  /// - [selection]: List of period IDs.
  D2PeriodSelection.fromSelection(List<String> selection) {
    if (selection.isNotEmpty) {
      D2Period period = D2PeriodType.getPeriodById(selection.first);
      selected = selection;
      category = period.category;
      type = period.type;
      displayName = period.name;
    } else {
      category = D2PeriodTypeCategory.relative;
    }
  }

  /// Creates a [D2PeriodSelection] object from JSON.
  ///
  /// - [json]: The map containing the period selection data.
  D2PeriodSelection.fromJSON(Map json) {
    selected = (json['periods'].cast<Map>())
        ?.map<String>((period) => period['id'] as String)
        .toList();
    Map<String, dynamic> relativePeriods =
        json['relativePeriods'] as Map<String, dynamic>;
    relativePeriods.removeWhere((key, value) => !value);
    if (relativePeriods.isNotEmpty) {
      selected?.addAll(relativePeriods.keys.map(uncamelize).toList());
    }
    if (selected?.isNotEmpty ?? false) {
      category = RegExp(r'^(\d{4})').hasMatch(selected?.first ?? '')
          ? D2PeriodTypeCategory.fixed
          : D2PeriodTypeCategory.relative;
    } else {
      category = D2PeriodTypeCategory.relative;
    }
  }

  /// Whether the category is range mode.
  get rangeMode => category == D2PeriodTypeCategory.range;

  /// Returns the selected period IDs.
  getSelectionId() {
    return selected;
  }

  /// Returns the display name for the period selection.
  String getDisplayName() {
    if (category == '') {}
    return 'Period header';
  }

  /// Clone constructor to create a copy of a [D2PeriodSelection] object.
  ///
  /// - [selection]: The [D2PeriodSelection] object to clone.
  D2PeriodSelection.clone(D2PeriodSelection selection) {
    category = selection.category;
    selected = [...?selection.selected];
    start = selection.start;
    type = selection.type;
    end = selection.end;
  }
}
