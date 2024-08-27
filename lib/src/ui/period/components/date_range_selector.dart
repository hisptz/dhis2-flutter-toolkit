/// Copyright (c) 2024, HISP Tanzania Developers.
/// All rights reserved. Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.

library;

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class D2DateRangeSelector extends StatelessWidget {
  final Function onUpdate;
  final DateTime? startDate;
  final DateTime? endDate;
  final Color color;

  D2DateRangeSelector({
    super.key,
    required this.onUpdate,
    required this.color,
    this.startDate,
    this.endDate,
  });
  final DateRangePickerController controller = DateRangePickerController();

  @override
  Widget build(BuildContext context) {
    return SfDateRangePicker(
      view: DateRangePickerView.month,
      initialSelectedRange: PickerDateRange(startDate, endDate),
      selectionMode: DateRangePickerSelectionMode.range,
      rangeSelectionColor: color.withOpacity(.3),
      selectionColor: color,
      startRangeSelectionColor: color,
      endRangeSelectionColor: color,
      onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
        onUpdate(args.value);
      },
    );
  }
}
