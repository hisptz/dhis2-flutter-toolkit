/// Copyright (c) 2024, HISP Tanzania Developers.
/// All rights reserved. Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.

library;

import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:flutter/material.dart';

class D2SelectedPeriodContainer extends StatelessWidget {
  D2SelectedPeriodContainer(
      {Key? key,
      required this.category,
      required this.periodType,
      required this.year,
      required this.onChange,
      required this.color,
      required this.selectedPeriods})
      : super(key: key);

   //Method to handle only one chip
  List<Widget> getSelectedPeriods(BuildContext context, List<dynamic> periods) {
    // Ensure only one chip by taking the first element or an empty list
    final latestPeriod = selectedPeriods?.last ?? '';
    return [
      if (latestPeriod.isNotEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: InputChip(
              side: BorderSide.none,
              onSelected: (bool selected) {
                // Call onChange with the latest period ID
                onChange(latestPeriod);
              },
              deleteIconColor: const Color(0xFF405261),
              onDeleted: () {
                onChange(latestPeriod);
              },
              label: Text(D2PeriodType.getPeriodById(latestPeriod).name),
              labelStyle: const TextStyle(color: Color(0xFF405261)),
              backgroundColor: color.withOpacity(0.2),
            ),
          ),
        )
    ];
  }

  final String category;
  final String? periodType;
  final List<String>? selectedPeriods;
  final int year;
  final Function onChange;
  final Color color;
  final ScrollController? controller = ScrollController();

  List<Widget> getPeriods(BuildContext context) {
    List<Widget> periodChips = [];
    if (periodType != null) {
      List<D2Period> periods =
          D2PeriodType.fromId(periodType!, category: category, year: year)
              .periods;
      periodChips.addAll(getSelectedPeriods(context, periods));
    }

    return periodChips;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selected Periods',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF405261)),
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.06,
              child: Scrollbar(
                controller: controller,
                thumbVisibility: true,
                scrollbarOrientation: ScrollbarOrientation.top,
                child: ListView(
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  children: [...getPeriods(context)],
                ),
              ))
        ],
      ),
    );
  }
}
