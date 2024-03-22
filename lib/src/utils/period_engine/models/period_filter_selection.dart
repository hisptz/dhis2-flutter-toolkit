/// Copyright (c) 2024, HISP Tanzania Developers.
/// All rights reserved. Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.

library;

import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:dhis2_flutter_toolkit/src/utils/period_engine/constants/period_categories.dart';

class D2PeriodSelection {
  late String category;
  String? type;
  List<String>? selected = [];
  DateTime? start;
  DateTime? end;

  String? displayName;

  // Constructor for PeriodSelection class
  D2PeriodSelection(
      {required this.category, this.type, this.selected, this.start, this.end});

  // Override toString method to customize string representation of the object
  @override
  String toString() {
    return "$category ${type ?? ''}";
  }

  // Utility method to convert camelCase to snake_case
  String uncamelize(String value, {String separator = '_'}) {
    return value.replaceAllMapped(RegExp(r'[A-Z]|\d+'), (match) {
      return '$separator${match[0]}';
    }).toUpperCase();
  }

  // Constructor to create PeriodSelection object from a list of selection IDs
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

  // Constructor to create PeriodSelection object from JSON
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

  // Getter method to check if the category is range
  get rangeMode => category == D2PeriodTypeCategory.range;

  getSelectionId() {
    return selected;
  }

  // Method to get the display name
  String getDisplayName() {
    if (category == '') {}
    return 'Period header';
  }

  // Clone constructor to clone a PeriodSelection object
  D2PeriodSelection.clone(D2PeriodSelection selection) {
    category = selection.category;
    selected = [...?selection.selected];
    start = selection.start;
    type = selection.type;
    end = selection.end;
  }
}
