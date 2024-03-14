///Copyright (c) 2024, HISP Tanzania Developers.
///All rights reserved. Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.

library;

import 'period_categories.dart';
import 'period_types.dart';

///This is the list of the supported relative period types on DHIS2
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
///This is a getter function for the daily relative periods
///It returns the list of Map of relative daily period types
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
///This is a getter function for the weekly relative periods
///It returns the list of Map of relative weekly period types
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
///This is a getter function for the biweekly relative periods
///It returns the list of Map of relative biweekly period types
//
getBiWeeksPeriodType() => [
      {"id": 'THIS_BIWEEK', "name": 'This bi-week'},
      {"id": 'LAST_BIWEEK', "name": 'Last bi-week'},
      {"id": 'LAST_4_BIWEEKS', "name": 'Last 4 bi-weeks'},
    ];

//
///This is a getter function for the monthly relative periods
///It returns the list of Map of relative monthly period types
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
///This is a getter function for the bimonthly relative periods
///It returns the list of Map of relative bimonthly period types
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
///This is a getter function for the quarterly relative periods
///It returns the list of Map of relative quarterly period types
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
///This is a getter function for the six monthly relative periods
///It returns the list of Map of relative six monthly period types
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
///This is a getter function for the financial years relative periods
///It returns the list of Map of relative financial years period types
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
///This is a getter function for the yearly relative periods
///It returns the list of Map of relative yearly period types
//
getYearsPeriodType() => [
      {"id": 'THIS_YEAR', "name": 'This year'},
      {"id": 'LAST_YEAR', "name": 'Last year'},
      {"id": 'LAST_5_YEARS', "name": 'Last 5 years'},
      {"id": 'LAST_10_YEARS', "name": 'Last 10 years'},
    ];
