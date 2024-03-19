/// Copyright (c) 2024, HISP Tanzania Developers.
/// All rights reserved. Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.

library;

import 'package:dhis2_flutter_toolkit/src/ui/period/components/selected_period_container.dart';
import '../../utils/period_engine/constants/fixed_period_types.dart';
import 'package:dhis2_flutter_toolkit/src/utils/period_engine/constants/period_categories.dart';
import 'package:dhis2_flutter_toolkit/src/utils/period_engine/constants/relative_period_types.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'components/date_range_selector.dart';
import 'components/period_selector.dart';
import 'components/period_type_selector.dart';
import '../../utils/period_engine/models/period_filter_selection.dart';

class D2PeriodSelector extends StatefulWidget {
  final Function d2onUpdate;
  final bool d2showRelative;
  final bool d2showRange;
  final bool d2showFixed;
  final Color d2Color;

  final D2PeriodSelection? d2initialSelection;
  final List<String>? d2excludePeriodTypes;
  final List<String>? d2onlyAllowPeriodTypes;

  const D2PeriodSelector({
    super.key,
    required this.d2onUpdate,
    this.d2excludePeriodTypes,
    this.d2onlyAllowPeriodTypes,
    this.d2initialSelection,
    required this.d2Color,
    this.d2showRelative = false,
    this.d2showRange = false,
    this.d2showFixed = true,
  });

  @override
  State<D2PeriodSelector> createState() => _PeriodSelectorState();
}

class _PeriodSelectorState extends State<D2PeriodSelector>
    with TickerProviderStateMixin {
  late TabController _controller;
  Map<String, String> periodTypes = {
    D2PeriodTypeCategory.relative: 'Relative',
    D2PeriodTypeCategory.fixed: 'Fixed',
    D2PeriodTypeCategory.range: 'Range',
  };
  late String? _selectedPeriodType;
  int year = DateTime.now().year;
  List<Map> validFixedPeriodTypes = d2FixedD2PeriodTypes;
  List<Map> validRelativePeriodTypes = d2RelativePeriodTypes;
  List<String> _selectedPeriods = [];
  late String _selectedCategory;
  DateTime? _start;
  DateTime? _end;

  List<String> getVisiblePeriodCategories() {
    List<String> categories = [];
    if (widget.d2showRelative) {
      categories.add(D2PeriodTypeCategory.relative);
    }
    if (widget.d2showFixed) {
      categories.add(D2PeriodTypeCategory.fixed);
    }
    if (widget.d2showRange) {
      categories.add(D2PeriodTypeCategory.range);
    }
    return categories;
  }

  onPeriodTypeChange(String type) {
    setState(() {
      _selectedPeriodType = type;
    });
  }

  onDateRangeChange(PickerDateRange range) {
    _start = range.startDate;
    _end = range.endDate ?? range.startDate;
  }

  onYearChange(int updatedYear) {
    setState(() {
      year = updatedYear;
    });
  }

  onPeriodToggle(String periodId) {
    setState(() {
      int index = _selectedPeriods.indexOf(periodId);
      if (index < 0) {
        _selectedPeriods.add(periodId);
      } else {
        _selectedPeriods.removeAt(index);
      }
    });
  }

  init() {
    _controller =
        TabController(length: getVisiblePeriodCategories().length, vsync: this);
    if (widget.d2onlyAllowPeriodTypes != null) {
      validRelativePeriodTypes = validRelativePeriodTypes
          .where((element) =>
              !widget.d2onlyAllowPeriodTypes!.contains(element['id']))
          .toList();
      validFixedPeriodTypes = validFixedPeriodTypes
          .where((element) =>
              !widget.d2onlyAllowPeriodTypes!.contains(element['id']))
          .toList();
    }
    if (widget.d2excludePeriodTypes != null) {
      validRelativePeriodTypes = validRelativePeriodTypes
          .where((element) =>
              !widget.d2excludePeriodTypes!.contains(element['id']))
          .toList();
      validFixedPeriodTypes = validFixedPeriodTypes
          .where((element) =>
              !widget.d2excludePeriodTypes!.contains(element['id']))
          .toList();
    }
    if (widget.d2initialSelection != null) {
      setState(() {
        _selectedCategory = widget.d2initialSelection?.category ?? '';
        _selectedPeriodType = widget.d2initialSelection?.type ??
            validFixedPeriodTypes.first['id'];
        _selectedPeriods = widget.d2initialSelection?.selected ?? [];
        _start = widget.d2initialSelection?.start;
        _end = widget.d2initialSelection?.end;
      });
      int selectedCategory = getVisiblePeriodCategories()
          .toList()
          .indexOf(widget.d2initialSelection?.category ?? '');
      _controller.animateTo(selectedCategory);
    } else {
      setState(() {
        _selectedPeriodType = validRelativePeriodTypes.first['id'];
      });
      onSelectPeriodType(0);
    }

    // Tabs Controller lister
    _controller.addListener(() {
      var index = _controller.index;
      var selectedPeriodCategory = getVisiblePeriodCategories()[index];
      onSelectPeriodType(
        index,
        shouldPresetInitial: selectedPeriodCategory != _selectedCategory,
      );
    });
  }

  void onSelectPeriodType(int index, {bool shouldPresetInitial = true}) {
    var selectedPeriodCategory = getVisiblePeriodCategories()[index];
    setState(() {
      _selectedCategory = selectedPeriodCategory;
      switch (selectedPeriodCategory) {
        case D2PeriodTypeCategory.fixed:
          _selectedPeriodType = !shouldPresetInitial
              ? _selectedPeriodType
              : widget.d2onlyAllowPeriodTypes?.first ??
                  validFixedPeriodTypes.first['id'];
          _start = null;
          _end = null;
          break;
        case D2PeriodTypeCategory.relative:
          _selectedPeriodType = !shouldPresetInitial
              ? _selectedPeriodType
              : validRelativePeriodTypes.first['id'];
          _start = null;
          _end = null;
          break;
        default:
          _selectedPeriodType = null;
          _selectedPeriods = [];
      }
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DefaultTabController(
            length: getVisiblePeriodCategories().length,
            child: Column(
              children: [
                Visibility(
                  visible: (widget.d2showRelative ||
                          (widget.d2showFixed && widget.d2showRange)) &&
                      (widget.d2showFixed ||
                          (widget.d2showRelative && widget.d2showRange)),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: TabBar(
                      controller: _controller,
                      labelColor: widget.d2Color,
                      indicatorColor: widget.d2Color,
                      unselectedLabelColor: Colors.black,
                      tabs: getVisiblePeriodCategories()
                          .map((category) => Tab(
                                text: periodTypes[category]!,
                              ))
                          .toList(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: D2PeriodTypeSelector(
                    _selectedCategory,
                    _selectedPeriodType,
                    onChange: onPeriodTypeChange,
                    inputColor: widget.d2Color,
                    year: year,
                    onYearChange: onYearChange,
                    allowedPeriodTypes: widget.d2onlyAllowPeriodTypes,
                    excludedPeriodTypes: widget.d2excludePeriodTypes,
                  ),
                ),
                Visibility(
                  visible: _selectedPeriods.isNotEmpty,
                  child: D2SelectedPeriodContainer(
                    category: _selectedCategory,
                    periodType: _selectedPeriodType,
                    selectedPeriods: _selectedPeriods,
                    color: widget.d2Color,
                    onChange: onPeriodToggle,
                    year: year,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2.8,
                  child: TabBarView(
                    controller: _controller,
                    children: getVisiblePeriodCategories()
                        .map(
                          (String category) => category ==
                                  D2PeriodTypeCategory.range
                              ? D2DateRangeSelector(
                                  onUpdate: onDateRangeChange,
                                  color: widget.d2Color,
                                  startDate: _start,
                                  endDate: _end)
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: D2PeriodValueSelector(
                                      category: _selectedCategory,
                                      periodType: _selectedPeriodType,
                                      selectedPeriods: _selectedPeriods,
                                      color: widget.d2Color,
                                      onChange: onPeriodToggle,
                                      year: year),
                                ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => widget.d2Color)),
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    widget.d2onUpdate(D2PeriodSelection(
                        category: _selectedCategory,
                        type: _selectedPeriodType,
                        selected: _selectedPeriods,
                        start: _start,
                        end: _end));
                  },
                ),
              ))
            ],
          )
        ],
      ),
    );
  }
}
