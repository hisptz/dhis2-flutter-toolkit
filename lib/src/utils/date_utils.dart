///Copyright (c) 2024, HISP Tanzania Developers.
///All rights reserved. Use of this source code is governed by a BSD-style license that can be found in the LICENSE file.

library;

//
///`DateUtils` is a collection of helper functions that performs date related functions
//
class D2DateUtils {
  //
  ///`DateUtils.calculateYearsBetweenDates` is the helper function that calculates the years between two dates
  ///It accepts the `DateTime` startDate and endDate and returns the `int` years between the dates
  //
  static int calculateYearsBetweenDates({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    int years = endDate.year - startDate.year;
    if (endDate.month < startDate.month ||
        (endDate.month == startDate.month && endDate.day < startDate.day)) {
      years--;
    }
    return years;
  }

  //
  ///`DateUtils.calculateMonthsBetweenDates` is the helper function that calculates the months between two dates
  ///It accepts the `DateTime` startDate and endDate and returns the `int` months between the dates
  //
  static int calculateMonthsBetweenDates({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    int months =
        (endDate.year - startDate.year) * 12 + endDate.month - startDate.month;
    if (endDate.day < startDate.day) {
      months--;
    }
    return months;
  }

  //
  ///`DateUtils.calculateWeeksBetweenDates` is the helper function that calculates the weeks between two dates
  ///It accepts the `DateTime` startDate and endDate and returns the `int` weeks between the dates
  //
  static int calculateWeeksBetweenDates({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final duration = endDate.difference(startDate);
    final days = duration.inDays;
    final weeks = (days / 7).floor();
    return weeks;
  }

  //
  ///`DateUtils.calculateDaysBetweenDates` is the helper function that calculates the days between two dates
  ///It accepts the `DateTime` startDate and endDate and returns the `int` days between the dates
  //
  static int calculateDaysBetweenDates({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final duration = endDate.difference(startDate);
    final days = duration.inDays;
    return days;
  }
}
