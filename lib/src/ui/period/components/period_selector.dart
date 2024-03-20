/// Copyright (c) 2024, HISP Tanzania Developers.
/// All rights reserved. Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.

library;

import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:flutter/material.dart';

class D2PeriodValueSelector extends StatelessWidget {
  final String category;
  final String? periodType;
  final List<String>? selectedPeriods;
  final Color color;
  final int year;
  final Function onChange;
  final ScrollController? controller = ScrollController();

  D2PeriodValueSelector(
      {Key? key,
      required this.category,
      required this.periodType,
      required this.year,
      required this.onChange,
      required this.color,
      required this.selectedPeriods})
      : super(key: key);

  List<Widget> getPeriodChips(List<dynamic> periods) {
    List<String> selectedPeriodsList = selectedPeriods ?? [];
    List<Widget> periodChips = [];
    for (D2Period period in periods) {
      bool selected = selectedPeriodsList.contains(period.id);
      if (!selected) {
        periodChips.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: InkWell(
            onTap: () {
              onChange(period.id);
            },
            child: Chip(
                label: Text(period.name),
                labelStyle:
                    TextStyle(color: selected ? Colors.white : Colors.black),
                avatar: selected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                      )
                    : null,
                backgroundColor: selected ? color : null),
          ),
        ));
      }
    }
    return periodChips;
  }

  List<Widget> getPeriods() {
    List<Widget> periodChips = [];
    if (periodType != null) {
      List<D2Period> periods =
          D2PeriodType.fromId(periodType!, category: category, year: year)
              .periods;
      periodChips.addAll(getPeriodChips(periods));
    }

    return periodChips;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Periods',
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF405261)),
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3.2,
            child: Scrollbar(
              scrollbarOrientation: ScrollbarOrientation.right,
              controller: controller,
              thumbVisibility: true,
              radius: const Radius.circular(4),
              child: SingleChildScrollView(
                controller: controller,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Wrap(
                  children: getPeriods(),
                ),
              ),
            )),
      ],
    );
  }
}