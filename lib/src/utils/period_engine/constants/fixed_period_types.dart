/// Copyright (c) 2024, HISP Tanzania Developers.
/// All rights reserved. Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.

library;

import 'package:dart_date/dart_date.dart';

import '../helpers/date.dart';
import 'period_categories.dart';
import 'period_types.dart';

///  This is a list of all DHIS2 supported fixed period types
///  Each individual period item from this list is a fixed period formatted onto a map necessary for different DHIS2 functionalities
List<Map<String, dynamic>> d2FixedD2PeriodTypes = [
  {
    "id": D2PeriodTypes.weekly,
    "name": "Weekly",
    "category": D2PeriodTypeCategory.fixed,
    "regex": RegExp(r'^(\d{4})W(\d{1,2})$'),

    /// YYYY"W"[1-53]
    "rank": 2,
    "unit": "week",
    "idGenerator": (Interval interval) =>
        "${interval.start.year}W${interval.start.getWeek}",
    "nameGenerator": (Interval interval) =>
        "Week ${interval.start.getWeek} ${formatDate(interval.start)} - ${formatDate(interval.end)}",
    "startOfWeek": true
  },
  {
    "id": D2PeriodTypes.weeklyWednesday,
    "name": "Weekly (Wednesday)",
    "category": D2PeriodTypeCategory.fixed,
    "unit": "week",
    "regex": RegExp(r'^([0-9]{4})(Wed)W([0-9]{1,2})$'),

    /// YYYY"WedW"[1-53]
    "rank": 2,
    "offset": {
      "unit": "day",
      "value": 2,
    },
    "startOfWeek": true,
    "idGenerator": (Interval interval) =>
        "${interval.start.year}WedW${interval.start.getWeek}",
    "nameGenerator": (Interval interval) =>
        "${"Week"} ${interval.start.getWeek} ${formatDate(interval.start)} - ${formatDate(interval.end)}",
  },
  {
    "id": D2PeriodTypes.weeklyThursday,
    "name": "Weekly (Thursday)",
    "category": D2PeriodTypeCategory.fixed,
    "unit": "week",
    "regex": RegExp(r'^([0-9]{4})(Thu)W([0-9]{1,2})$'),

    /// YYYY"WedW"[1-53]
    "rank": 2,
    "offset": {
      "unit": "day",
      "value": 3,
    },
    "startOfWeek": true,
    "idGenerator": (Interval interval) =>
        "${interval.start.year}ThuW${interval.start.getWeek}",
    "nameGenerator": (Interval interval) =>
        "${"Week"} ${interval.start.getWeek} ${formatDate(interval.start)} - ${formatDate(interval.end)}",
  },
  {
    "id": D2PeriodTypes.weeklySaturday,
    "name": "Weekly (Saturday)",
    "category": D2PeriodTypeCategory.fixed,
    "unit": "week",
    "regex": RegExp(r'^([0-9]{4})(Sat)W([0-9]{1,2})$'),

    /// YYYY"WedW"[1-53]
    "rank": 2,
    "offset": {
      "unit": "day",
      "value": 5,
    },
    "startOfWeek": true,
    "idGenerator": (Interval interval) =>
        "${interval.start.year}SatW${interval.start.getWeek}",
    "nameGenerator": (Interval interval) =>
        "${"Week"} ${interval.start.getWeek} ${formatDate(interval.start)} - ${formatDate(interval.end)}",
  },
  {
    "id": D2PeriodTypes.weeklySunday,
    "name": "Weekly (Saturday)",
    "category": D2PeriodTypeCategory.fixed,
    "unit": "week",
    "regex": RegExp(r'^([0-9]{4})(Sun)W([0-9]{1,2})$'),

    /// YYYY"WedW"[1-53]
    "rank": 2,
    "offset": {
      "unit": "day",
      "value": 6,
    },
    "startOfWeek": true,
    "idGenerator": (Interval interval) =>
        "${interval.start.year}SunW${interval.start.getWeek}",
    "nameGenerator": (Interval interval) =>
        "${"Week"} ${interval.start.getWeek} ${formatDate(interval.start)} - ${formatDate(interval.end)}",
  },
  {
    "id": D2PeriodTypes.biWeekly,
    "name": "Biweekly",
    "category": D2PeriodTypeCategory.fixed,
    "unit": "week",
    "regex": RegExp(r'^([0-9]{4})BiW([0-9]{1,2})$'),

    /// YYYY"BiW"[1-27]
    "rank": 3,
    "factor": 2,
    "startOfWeek": true,
    "idGenerator": (Interval interval) =>
        "${interval.start.year}BiW${(interval.start.getWeek / 2).ceil()}",
    "nameGenerator": (Interval interval) =>
        "${"Bi-Week"} ${(interval.start.getWeek / 2).ceil()} ${formatDate(interval.start)} - ${formatDate(interval.end)}",
  },
  {
    "id": D2PeriodTypes.monthly,
    "name": "Monthly",
    "category": D2PeriodTypeCategory.fixed,
    "unit": "month",
    "regex": RegExp(r'^([0-9]{4})([0-9]{2})$'),

    /// YYYYMM,
    "rank": 4,
    "idGenerator": (Interval interval) =>
        "${interval.start.year}${interval.start.month.toString().padLeft(2, '0')}",
    "nameGenerator": (Interval interval) => interval.start.format('MMMM yyyy')
  },
  {
    "id": D2PeriodTypes.biMonthly,
    "name": "Bi-monthly",
    "category": D2PeriodTypeCategory.fixed,
    "unit": "month",
    "regex": RegExp(r'^([0-9]{4})([0-9]{2})B$'),

    /// YYYY0[1-6]"B"
    "rank": 5,
    "factor": 2,
    "idGenerator": (Interval interval) =>
        "${interval.start.year}${interval.start.month.toString().padLeft(2, '0')}B",
    "nameGenerator": (Interval interval) =>
        "${interval.start.format('MMMM')} - ${interval.end.format('MMMM')} ${interval.start.year}"
  },
  {
    "id": D2PeriodTypes.quarterly,
    "name": "Quarterly",
    "category": D2PeriodTypeCategory.fixed,
    "unit": "quarter",
    "regex": RegExp(r'^([0-9]{4})Q([1234])$'),

    /// YYYY"Q"[1-4]
    "rank": 6,
    "idGenerator": (Interval interval) =>
        "${interval.start.year}Q${(interval.start.getMonth / 3).floor() + 1}",
    "nameGenerator": (Interval interval) =>
        "${interval.start.format("MMMM")} - ${interval.end.format("MMMM")} ${interval.start.year}"
  },
  {
    "id": D2PeriodTypes.sixMonthly,
    "name": "Six-monthly",
    "category": D2PeriodTypeCategory.fixed,
    "unit": "quarter",
    "regex": RegExp(r'^([0-9]{4})S([12])$'),

    /// YYYY"S"[1/2]
    "rank": 7,
    "factor": 2,
    "idGenerator": (Interval interval) =>
        "${interval.start.year}S${(interval.start.getMonth / 6).floor() + 1}",
    "nameGenerator": (Interval interval) =>
        "${interval.start.format('MMMM')} - ${interval.end.format("MMMM")} ${interval.start.year}"
  },
  {
    "id": D2PeriodTypes.sixMonthlyApril,
    "name": "Six-monthly (April)",
    "category": D2PeriodTypeCategory.fixed,
    "unit": "quarter",
    "regex": RegExp(r'^([0-9]{4})AprilS([12])$'),

    /// YYYY"AprilS"[1/2]
    "rank": 7,
    "factor": 2,
    "offset": {"unit": "quarter", "value": 1},
    "idGenerator": (Interval interval) =>
        "${interval.start.year}AprilS${(interval.start.getMonth / 6).floor() + 1}",
    "nameGenerator": (Interval interval) =>
        "${interval.start.format('MMMM')}${interval.start.year == interval.end.year ? ' ' : " ${interval.start.year} "}- ${interval.end.format('MMMM')} ${interval.end.year}"
  },
  {
    "id": D2PeriodTypes.yearly,
    "name": "Yearly",
    "category": D2PeriodTypeCategory.fixed,
    "unit": "year",
    "regex": RegExp(r'^([0-9]{4})$'),

    /// YYYY
    "rank": 8,
    "idGenerator": (Interval interval) => "${interval.start.year}",
    "nameGenerator": (Interval interval) => "${interval.start.year}",
  },
  {
    "id": D2PeriodTypes.financialYearNovember,
    "name": "Financial year (November)",
    "category": D2PeriodTypeCategory.fixed,
    "unit": "year",
    "regex": RegExp(r'^([0-9]{4})Nov$'),

    /// YYYY"Nov"
    "rank": 8,
    "offset": {"unit": "month", "value": 10},
    "idGenerator": (Interval interval) => "${interval.start.year}Nov",
    "nameGenerator": (Interval interval) =>
        "${interval.start.format("MMMM yyyy")} - ${interval.end.format("MMMM yyyy")}",
  },
  {
    "id": D2PeriodTypes.financialYearOctober,
    "name": "Financial year (October)",
    "category": D2PeriodTypeCategory.fixed,
    "unit": "year",
    "regex": RegExp(r'^([0-9]{4})Oct$'),

    /// YYYY"Nov"
    "rank": 8,
    "offset": {"unit": "month", "value": 9},
    "idGenerator": (Interval interval) => "${interval.start.year}Oct",
    "nameGenerator": (Interval interval) =>
        "${interval.start.format("MMMM yyyy")} - ${interval.end.format("MMMM yyyy")}",
  },
  {
    "id": D2PeriodTypes.financialYearJuly,
    "name": "Financial year (July)",
    "category": D2PeriodTypeCategory.fixed,
    "unit": "year",
    "regex": RegExp(r'^([0-9]{4})July$'),

    /// YYYY"Nov"
    "rank": 8,
    "offset": {"unit": "month", "value": 6},
    "idGenerator": (Interval interval) => "${interval.start.year}July",
    "nameGenerator": (Interval interval) =>
        "${interval.start.format("MMMM yyyy")} - ${interval.end.format("MMMM yyyy")}",
  },
  {
    "id": D2PeriodTypes.financialYearApril,
    "name": "Financial year (April)",
    "category": D2PeriodTypeCategory.fixed,
    "unit": "year",
    "regex": RegExp(r'^([0-9]{4})April$'),

    /// YYYY"Nov"
    "rank": 8,
    "offset": {"unit": "month", "value": 3},
    "idGenerator": (Interval interval) => "${interval.start.year}April",
    "nameGenerator": (Interval interval) =>
        "${interval.start.format("MMMM yyyy")} - ${interval.end.format("MMMM yyyy")}",
  }
];
