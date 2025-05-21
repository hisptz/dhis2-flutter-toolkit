/// Copyright (c) 2024, HISP Tanzania Developers.
/// All rights reserved. Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.

library;

import 'package:dart_date/dart_date.dart';

import 'period_categories.dart';
import 'period_types.dart';

/// This is the list of the supported relative period types on DHIS2
//

List<Map<String, dynamic>> d2RelativePeriodTypes = [
  {
    "id": D2PeriodTypes.daily,
    "getPeriods": () => getDaysPeriodType(),
    "name": 'Days',
    "category": D2PeriodTypeCategory.relative,
    "unit": "day"
  },
  {
    "id": D2PeriodTypes.weekly,
    "getPeriods": () => getWeeksPeriodType(),
    "name": 'Weeks',
    "category": D2PeriodTypeCategory.relative,
    "unit": 'week',
  },
  {
    "id": D2PeriodTypes.biWeekly,
    "getPeriods": () => getBiWeeksPeriodType(),
    "category": D2PeriodTypeCategory.relative,
    "name": 'Bi-weeks',
    "unit": "week"
  },
  {
    "id": D2PeriodTypes.monthly,
    "getPeriods": () => getMonthsPeriodType(),
    "name": 'Months',
    "category": D2PeriodTypeCategory.relative,
    "unit": "month",
  },
  {
    "id": D2PeriodTypes.biMonthly,
    "getPeriods": () => getBiMonthsPeriodType(),
    "name": 'Bi-months',
    "category": D2PeriodTypeCategory.relative,
    "unit": "month",
  },
  {
    "id": D2PeriodTypes.quarterly,
    "getPeriods": () => getQuartersPeriodType(),
    "name": 'Quarters',
    "category": D2PeriodTypeCategory.relative,
    "unit": "month"
  },
  {
    "id": D2PeriodTypes.sixMonthly,
    "getPeriods": () => getSixMonthsPeriodType(),
    "name": 'Six-months',
    "category": D2PeriodTypeCategory.relative,
    "unit": "month"
  },
  {
    "id": D2PeriodTypes.financial,
    "getPeriods": () => getFinancialYearsPeriodType(),
    "name": 'Financial Years',
    "category": D2PeriodTypeCategory.relative,
    "unit": "year"
  },
  {
    "id": D2PeriodTypes.yearly,
    "getPeriods": () => getYearsPeriodType(),
    "name": 'Years',
    "category": D2PeriodTypeCategory.relative,
    "unit": "year"
  },
];

//
/// This is a getter function for the daily relative periods
/// It returns the list of Map of relative daily period types
//
getDaysPeriodType() => [
      {"id": 'TODAY', "name": 'Today'},
      {"id": 'YESTERDAY', "name": 'Yesterday'},
      {"id": 'LAST_3_DAYS', "name": 'Last 3 days'},
      {"id": 'LAST_7_DAYS', "name": 'Last 7 days'},
      {"id": 'LAST_14_DAYS', "name": 'Last 14 days'},
      {"id": 'LAST_30_DAYS', "name": 'Last 30 days'},
      {"id": 'LAST_60_DAYS', "name": 'Last 60 days'},
      {"id": 'LAST_90_DAYS', "name": 'Last 90 days'},
      {"id": 'LAST_180_DAYS', "name": 'Last 180 days'},
    ];

//
/// This is a getter function for the weekly relative periods
/// It returns the list of Map of relative weekly period types
//
getWeeksPeriodType() => [
      {"id": 'THIS_WEEK', "name": 'This week'},
      {"id": 'LAST_WEEK', "name": 'Last week'},
      {"id": 'LAST_4_WEEKS', "name": 'Last 4 weeks'},
      {"id": 'LAST_12_WEEKS', "name": 'Last 12 weeks'},
      {"id": 'LAST_52_WEEKS', "name": 'Last 52 weeks'},
      {"id": D2PeriodTypes.weeksThisYear, "name": 'Weeks this year'},
    ];

//
/// This is a getter function for the biweekly relative periods
/// It returns the list of Map of relative biweekly period types
//
getBiWeeksPeriodType() => [
      {"id": 'THIS_BIWEEK', "name": 'This bi-week'},
      {"id": 'LAST_BIWEEK', "name": 'Last bi-week'},
      {"id": 'LAST_4_BIWEEKS', "name": 'Last 4 bi-weeks'},
    ];

//
/// This is a getter function for the monthly relative periods
/// It returns the list of Map of relative monthly period types
//
getMonthsPeriodType() => [
      {"id": 'THIS_MONTH', "name": 'This month'},
      {"id": 'LAST_MONTH', "name": 'Last month'},
      {"id": 'LAST_3_MONTHS', "name": 'Last 3 months'},
      {"id": 'LAST_6_MONTHS', "name": 'Last 6 months'},
      {"id": 'LAST_12_MONTHS', "name": 'Last 12 months'},
      {
        "id": 'MONTHS_THIS_YEAR',
        "name": 'Months this year',
      },
    ];

//
/// This is a getter function for the bimonthly relative periods
/// It returns the list of Map of relative bimonthly period types
//
getBiMonthsPeriodType() => [
      {"id": 'THIS_BIMONTH', "name": 'This bi-month'},
      {"id": 'LAST_BIMONTH', "name": 'Last bi-month'},
      {
        "id": 'LAST_6_BIMONTHS',
        "name": 'Last 6 bi-months',
      },
      {
        "id": 'BIMONTHS_THIS_YEAR',
        "name": 'Bi-months this year',
      },
    ];

//
/// This is a getter function for the quarterly relative periods
/// It returns the list of Map of relative quarterly period types
//
getQuartersPeriodType() => [
      {"id": 'THIS_QUARTER', "name": 'This quarter'},
      {"id": 'LAST_QUARTER', "name": 'Last quarter'},
      {"id": 'LAST_4_QUARTERS', "name": 'Last 4 quarters'},
      {
        "id": 'QUARTERS_THIS_YEAR',
        "name": 'Quarters this year',
      },
    ];

//
/// This is a getter function for the six monthly relative periods
/// It returns the list of Map of relative six monthly period types
//
getSixMonthsPeriodType() => [
      {"id": 'THIS_SIX_MONTH', "name": 'This six-month'},
      {"id": 'LAST_SIX_MONTH', "name": 'Last six-month'},
      {
        "id": 'LAST_2_SIXMONTHS',
        "name": 'Last 2 six-month',
      },
    ];

//
/// This is a getter function for the financial years relative periods
/// It returns the list of Map of relative financial years period types
//
getFinancialYearsPeriodType() => [
      {
        "id": 'THIS_FINANCIAL_YEAR',
        "name": 'This financial year',
      },
      {
        "id": 'LAST_FINANCIAL_YEAR',
        "name": 'Last financial year',
      },
      {
        "id": 'LAST_5_FINANCIAL_YEARS',
        "name": 'Last 5 financial years',
      },
    ];

//
/// This is a getter function for the yearly relative periods
/// It returns the list of Map of relative yearly period types
//
getYearsPeriodType() => [
      {"id": 'THIS_YEAR', "name": 'This year'},
      {"id": 'LAST_YEAR', "name": 'Last year'},
      {"id": 'LAST_5_YEARS', "name": 'Last 5 years'},
      {"id": 'LAST_10_YEARS', "name": 'Last 10 years'},
    ];

Interval? getIntervalForRelativePeriod(String id, {DateTime? reference}) {
  final now = reference ?? DateTime.now();
  switch (id) {
    case 'TODAY':
      return Interval(now.startOfDay, now.endOfDay);

    case 'YESTERDAY':
      final yesterday = now.subtract(const Duration(days: 1));
      return Interval(yesterday.startOfDay, yesterday.endOfDay);

    case 'LAST_3_DAYS':
      final start3 = now.subtract(const Duration(days: 2)).startOfDay;
      return Interval(start3, now.endOfDay);

    case 'LAST_7_DAYS':
      final start = now.subtract(const Duration(days: 6)).startOfDay;
      final end = now.endOfDay;
      return Interval(start, end);

    case 'LAST_14_DAYS':
      final start14 = now.subtract(const Duration(days: 13)).startOfDay;
      return Interval(start14, now.endOfDay);

    case 'LAST_30_DAYS':
      final start30 = now.subtract(const Duration(days: 29)).startOfDay;
      return Interval(start30, now.endOfDay);

    case 'LAST_60_DAYS':
      final start60 = now.subtract(const Duration(days: 59)).startOfDay;
      return Interval(start60, now.endOfDay);

    case 'LAST_90_DAYS':
      final start90 = now.subtract(const Duration(days: 89)).startOfDay;
      return Interval(start90, now.endOfDay);

    case 'LAST_180_DAYS':
      final start180 = now.subtract(const Duration(days: 179)).startOfDay;
      return Interval(start180, now.endOfDay);

    case 'THIS_WEEK':
      return Interval(now.startOfWeek, now.endOfWeek);

    case 'LAST_WEEK':
      final lastWeek = now.subtract(const Duration(days: 7));
      return Interval(lastWeek.startOfWeek, lastWeek.endOfWeek);

    case 'LAST_4_WEEKS':
      final start = now.subtract(const Duration(days: 7 * 3)).startOfWeek;
      return Interval(start, now.endOfWeek);

    case 'LAST_12_WEEKS':
      final start = now.subtract(const Duration(days: 7 * 11)).startOfWeek;
      return Interval(start, now.endOfWeek);

    case 'LAST_52_WEEKS':
      final start = now.subtract(const Duration(days: 7 * 51)).startOfWeek;
      return Interval(start, now.endOfWeek);

    case 'WEEKS_THIS_YEAR':
      final start = DateTime(now.year, 1, 1).startOfWeek;
      return Interval(start, now.endOfWeek);

    case 'THIS_BIWEEK':
      final isFirstBiweek = now.difference(now.startOfWeek).inDays < 7;
      final start = isFirstBiweek
          ? now.startOfWeek
          : now.startOfWeek.subtract(const Duration(days: 7));
      final end = start.add(const Duration(days: 13)).endOfDay;
      return Interval(start, end);

    case 'LAST_BIWEEK':
      final isFirstBiweek = now.difference(now.startOfWeek).inDays < 7;
      final end = isFirstBiweek
          ? now.startOfWeek.subtract(const Duration(days: 1)).endOfDay
          : now.startOfWeek.subtract(const Duration(days: 8)).endOfDay;
      final start = end.subtract(const Duration(days: 13)).startOfDay;
      return Interval(start, end);

    case 'LAST_4_BIWEEKS':
      final isFirstBiweek = now.difference(now.startOfWeek).inDays < 7;
      final end = isFirstBiweek
          ? now.startOfWeek.subtract(const Duration(days: 1)).endOfDay
          : now.startOfWeek.subtract(const Duration(days: 8)).endOfDay;
      final start = end.subtract(const Duration(days: 13 * 4 - 1)).startOfDay;
      return Interval(start, end);

    case 'THIS_MONTH':
      return Interval(now.startOfMonth, now.endOfMonth);

    case 'LAST_MONTH':
      final lastMonth = DateTime(now.year, now.month - 1);
      return Interval(lastMonth.startOfMonth, lastMonth.endOfMonth);

    case 'LAST_3_MONTHS':
      final start = DateTime(now.year, now.month - 2).startOfMonth;
      return Interval(start, now.endOfMonth);

    case 'LAST_6_MONTHS':
      final start = DateTime(now.year, now.month - 5).startOfMonth;
      return Interval(start, now.endOfMonth);

    case 'LAST_12_MONTHS':
      final start = DateTime(now.year, now.month - 11).startOfMonth;
      return Interval(start, now.endOfMonth);

    case 'MONTHS_THIS_YEAR':
      final start = DateTime(now.year, 1, 1).startOfMonth;
      return Interval(start, now.endOfMonth);

    case 'THIS_BIMONTH':
      final biMonthStartMonth =
          (now.month % 2 == 0) ? now.month - 1 : now.month;
      final start = DateTime(now.year, biMonthStartMonth).startOfMonth;
      final end = DateTime(now.year, biMonthStartMonth + 1).endOfMonth;
      return Interval(start, end);

    case 'LAST_BIMONTH':
      final thisBiMonthStartMonth =
          (now.month % 2 == 0) ? now.month - 1 : now.month;
      final lastBiMonthStartMonth = thisBiMonthStartMonth - 2;
      final adjustedYear = now.year - (lastBiMonthStartMonth < 1 ? 1 : 0);
      final startMonth = (lastBiMonthStartMonth < 1)
          ? 12 + lastBiMonthStartMonth
          : lastBiMonthStartMonth;
      final start = DateTime(adjustedYear, startMonth).startOfMonth;
      final end = DateTime(adjustedYear, startMonth + 1).endOfMonth;
      return Interval(start, end);

    case 'LAST_6_BIMONTHS':
      final thisBiMonthStartMonth =
          (now.month % 2 == 0) ? now.month - 1 : now.month;
      final startMonth = thisBiMonthStartMonth - (2 * 5);
      final adjustedStartYear =
          now.year - ((startMonth < 1) ? ((-startMonth + 1) ~/ 12 + 1) : 0);
      final normalizedStartMonth =
          (startMonth < 1) ? 12 + (startMonth % 12) : startMonth;
      final start =
          DateTime(adjustedStartYear, normalizedStartMonth).startOfMonth;
      final end = DateTime(now.year, thisBiMonthStartMonth + 1).endOfMonth;
      return Interval(start, end);

    case 'BIMONTHS_THIS_YEAR':
      final start = DateTime(now.year, 1).startOfMonth;
      final end = now.endOfMonth;
      return Interval(start, end);

    case 'THIS_QUARTER':
      final currentQuarter = ((now.month - 1) ~/ 3) + 1;
      final startMonth = (currentQuarter - 1) * 3 + 1;
      final start = DateTime(now.year, startMonth).startOfMonth;
      final end = DateTime(now.year, startMonth + 2).endOfMonth;
      return Interval(start, end);

    case 'LAST_QUARTER':
      final currentQuarter = ((now.month - 1) ~/ 3) + 1;
      int lastQuarter = currentQuarter - 1;
      int year = now.year;
      if (lastQuarter < 1) {
        lastQuarter = 4;
        year -= 1;
      }
      final startMonth = (lastQuarter - 1) * 3 + 1;
      final start = DateTime(year, startMonth).startOfMonth;
      final end = DateTime(year, startMonth + 2).endOfMonth;
      return Interval(start, end);

    case 'LAST_4_QUARTERS':
      final currentQuarter = ((now.month - 1) ~/ 3) + 1;
      final startQuarter = currentQuarter - 3;
      int startYear = now.year;
      int startQuarterAdjusted = startQuarter;
      if (startQuarter < 1) {
        startYear -= 1;
        startQuarterAdjusted = 4 + startQuarter;
      }
      final startMonth = (startQuarterAdjusted - 1) * 3 + 1;
      final start = DateTime(startYear, startMonth).startOfMonth;
      final endQuarterMonth = (currentQuarter - 1) * 3 + 3;
      final end = DateTime(now.year, endQuarterMonth).endOfMonth;
      return Interval(start, end);

    case 'QUARTERS_THIS_YEAR':
      final start = DateTime(now.year, 1).startOfMonth;
      final end = now.endOfMonth;
      return Interval(start, end);

    case 'THIS_SIX_MONTH':
      final half = (now.month <= 6) ? 1 : 2;
      final startMonth = (half == 1) ? 1 : 7;
      final start = DateTime(now.year, startMonth).startOfMonth;
      final end = DateTime(now.year, startMonth + 5).endOfMonth;
      return Interval(start, end);

    case 'LAST_SIX_MONTH':
      final half = (now.month <= 6) ? 1 : 2;
      int lastHalf = half - 1;
      int year = now.year;
      if (lastHalf < 1) {
        lastHalf = 2;
        year -= 1;
      }
      final startMonth = (lastHalf == 1) ? 1 : 7;
      final start = DateTime(year, startMonth).startOfMonth;
      final end = DateTime(year, startMonth + 5).endOfMonth;
      return Interval(start, end);

    case 'LAST_2_SIXMONTHS':
      final half = (now.month <= 6) ? 1 : 2;
      int startHalf = half - 1;
      int startYear = now.year;
      if (startHalf < 1) {
        startHalf = 2;
        startYear -= 1;
      }
      final startMonth = (startHalf == 1) ? 1 : 7;
      final start = DateTime(startYear, startMonth).startOfMonth;
      final endMonth = (half == 1) ? 6 : 12;
      final end = DateTime(now.year, endMonth).endOfMonth;
      return Interval(start, end);

    case 'THIS_FINANCIAL_YEAR':
      return Interval(now.startOfYear, now.endOfYear);

    case 'LAST_FINANCIAL_YEAR':
      final lastYear = DateTime(now.year - 1);
      return Interval(lastYear.startOfYear, lastYear.endOfYear);

    case 'LAST_5_FINANCIAL_YEARS':
      final start = DateTime(now.year - 4).startOfYear;
      return Interval(start, now.endOfYear);

    case 'THIS_YEAR':
      return Interval(now.startOfYear, now.endOfYear);

    case 'LAST_YEAR':
      final lastYear = DateTime(now.year - 1);
      return Interval(lastYear.startOfYear, lastYear.endOfYear);

    case 'LAST_5_YEARS':
      final start5 = DateTime(now.year - 4).startOfYear;
      return Interval(start5, now.endOfYear);

    case 'LAST_10_YEARS':
      final start10 = DateTime(now.year - 9).startOfYear;
      return Interval(start10, now.endOfYear);

    default:
      return null;
  }
}
