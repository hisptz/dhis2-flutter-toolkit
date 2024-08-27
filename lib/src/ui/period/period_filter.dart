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
  final Function onUpdate;
  final bool showRelative;
  final bool showRange;
  final bool showFixed;
  final Color color;

  final D2PeriodSelection? initialSelection;
  final List<String>? excludePeriodTypes;
  final List<String>? onlyAllowPeriodTypes;

  const D2PeriodSelector({
    super.key,
    required this.onUpdate,
    this.excludePeriodTypes,
    this.onlyAllowPeriodTypes,
    this.initialSelection,
    required this.color,
    this.showRelative = false,
    this.showRange = false,
    this.showFixed = true,
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
    if (widget.showRelative) {
      categories.add(D2PeriodTypeCategory.relative);
    }
    if (widget.showFixed) {
      categories.add(D2PeriodTypeCategory.fixed);
    }
    if (widget.showRange) {
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
    if (widget.onlyAllowPeriodTypes != null) {
      validRelativePeriodTypes = validRelativePeriodTypes
          .where((element) =>
              !widget.onlyAllowPeriodTypes!.contains(element['id']))
          .toList();
      validFixedPeriodTypes = validFixedPeriodTypes
          .where((element) =>
              !widget.onlyAllowPeriodTypes!.contains(element['id']))
          .toList();
    }
    if (widget.excludePeriodTypes != null) {
      validRelativePeriodTypes = validRelativePeriodTypes
          .where(
              (element) => !widget.excludePeriodTypes!.contains(element['id']))
          .toList();
      validFixedPeriodTypes = validFixedPeriodTypes
          .where(
              (element) => !widget.excludePeriodTypes!.contains(element['id']))
          .toList();
    }
    if (widget.initialSelection != null) {
      setState(
        () {
          _selectedCategory = widget.initialSelection?.category ?? '';
          _selectedPeriodType = widget.initialSelection?.type ??
              validFixedPeriodTypes.first['id'];
          _selectedPeriods = widget.initialSelection?.selected ?? [];
          _start = widget.initialSelection?.start;
          _end = widget.initialSelection?.end;
          if (_selectedPeriods.isNotEmpty) {
            year = int.parse(_selectedPeriods.last.substring(0, 4));
          } else {
            year = DateTime.now().year;
          }
        },
      );
      int selectedCategory = getVisiblePeriodCategories()
          .toList()
          .indexOf(widget.initialSelection?.category ?? '');
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
              : widget.onlyAllowPeriodTypes?.first ??
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultTabController(
          length: getVisiblePeriodCategories().length,
          child: Column(
            children: [
              Visibility(
                visible: (widget.showRelative ||
                        (widget.showFixed && widget.showRange)) &&
                    (widget.showFixed ||
                        (widget.showRelative && widget.showRange)),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: TabBar(
                    controller: _controller,
                    labelColor: widget.color,
                    indicatorColor: widget.color,
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
                  inputColor: widget.color,
                  year: year,
                  onYearChange: onYearChange,
                  allowedPeriodTypes: widget.onlyAllowPeriodTypes,
                  excludedPeriodTypes: widget.excludePeriodTypes,
                ),
              ),
              Visibility(
                visible: _selectedPeriods.isNotEmpty,
                child: D2SelectedPeriodContainer(
                  category: _selectedCategory,
                  periodType: _selectedPeriodType,
                  selectedPeriods: _selectedPeriods,
                  color: widget.color,
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
                                color: widget.color,
                                startDate: _start,
                                endDate: _end)
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: D2PeriodValueSelector(
                                    category: _selectedCategory,
                                    periodType: _selectedPeriodType,
                                    selectedPeriods: _selectedPeriods,
                                    color: widget.color,
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
                    backgroundColor: WidgetStateColor.resolveWith(
                        (states) => widget.color)),
                child: const Text(
                  'Update',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  widget.onUpdate(D2PeriodSelection(
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
    );
  }
}
