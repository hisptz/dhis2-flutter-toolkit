import "package:intl/intl.dart";

// Function to calculate previous day
String _getPreviousDay(int year, int month, int day) {
  DateTime date = DateTime(year, month, day);
  DateTime previousDate = date.subtract(const Duration(days: 1));
  return DateFormat('yyyyMMdd').format(previousDate);
}

// Function to calculate next day
String _getNextDay(int year, int month, int day) {
  DateTime date = DateTime(year, month, day);
  DateTime nextDate = date.add(const Duration(days: 1));
  return DateFormat('yyyyMMdd').format(nextDate);
}

// Function to calculate previous month
String _getPreviousMonth(int year, int month) {
  if (month == 1) {
    year -= 1;
    month = 12;
  } else {
    month -= 1;
  }
  return '$year${month.toString().padLeft(2, '0')}';
}

// Function to calculate next month
String _getNextMonth(int year, int month) {
  if (month == 12) {
    year += 1;
    month = 1;
  } else {
    month += 1;
  }
  return '$year${month.toString().padLeft(2, '0')}';
}

// Function to calculate previous week
String _getPreviousWeek(int year, int week) {
  // Handling the year transition when week is 1
  if (week == 1) {
    DateTime date = DateTime(year - 1, 12, 31);
    while (date.weekday != DateTime.thursday) {
      date = date.subtract(const Duration(days: 1));
    }
    int previousWeek = int.parse(DateFormat('w').format(date));
    int previousYear = date.year;
    return '${previousYear}W${previousWeek.toString().padLeft(2, '0')}';
  }
  DateTime date = DateFormat("yyyy-'W'ww")
      .parse('$year-W${week.toString().padLeft(2, '0')}');
  DateTime previousWeekDate = date.subtract(const Duration(days: 7));
  int previousWeek = int.parse(DateFormat('w').format(previousWeekDate));
  int previousYear = previousWeekDate.year;
  return '${previousYear}W${previousWeek.toString().padLeft(2, '0')}';
}

// Function to calculate next week
String _getNextWeek(int year, int week) {
  DateTime date = DateFormat("yyyy-'W'ww")
      .parse('$year-W${week.toString().padLeft(2, '0')}');
  DateTime nextWeekDate = date.add(const Duration(days: 7));
  int nextWeek = int.parse(DateFormat('w').format(nextWeekDate));
  int nextYear = nextWeekDate.year;
  return '${nextYear}W${nextWeek.toString().padLeft(2, '0')}';
}

// Function to calculate previous quarter
String _getPreviousQuarter(int year, int quarter) {
  if (quarter == 1) {
    year -= 1;
    quarter = 4;
  } else {
    quarter -= 1;
  }
  return '${year}Q$quarter';
}

// Function to calculate next quarter
String _getNextQuarter(int year, int quarter) {
  if (quarter == 4) {
    year += 1;
    quarter = 1;
  } else {
    quarter += 1;
  }
  return '${year}Q$quarter';
}

// Function to calculate next period ID
String getNextPeriodId(String periodId) {
  if (RegExp(r'^\d{8}$').hasMatch(periodId)) {
    int year = int.parse(periodId.substring(0, 4));
    int month = int.parse(periodId.substring(4, 6));
    int day = int.parse(periodId.substring(6, 8));
    return _getNextDay(year, month, day);
  } else if (RegExp(r'^\d{6}$').hasMatch(periodId)) {
    int year = int.parse(periodId.substring(0, 4));
    int month = int.parse(periodId.substring(4, 6));
    return _getNextMonth(year, month);
  } else if (RegExp(r'^\d{4}W\d{2}$').hasMatch(periodId)) {
    int year = int.parse(periodId.substring(0, 4));
    int week = int.parse(periodId.substring(5, 7));
    return _getNextWeek(year, week);
  } else if (RegExp(r'^\d{4}Q\d$').hasMatch(periodId)) {
    int year = int.parse(periodId.substring(0, 4));
    int quarter = int.parse(periodId.substring(5, 6));
    return _getNextQuarter(year, quarter);
  } else {
    throw ArgumentError("Invalid period ID format");
  }
}

// Function to calculate previous period ID
String getPreviousPeriodId(String periodId) {
  if (RegExp(r'^\d{8}$').hasMatch(periodId)) {
    int year = int.parse(periodId.substring(0, 4));
    int month = int.parse(periodId.substring(4, 6));
    int day = int.parse(periodId.substring(6, 8));
    return _getPreviousDay(year, month, day);
  } else if (RegExp(r'^\d{6}$').hasMatch(periodId)) {
    int year = int.parse(periodId.substring(0, 4));
    int month = int.parse(periodId.substring(4, 6));
    return _getPreviousMonth(year, month);
  } else if (RegExp(r'^\d{4}W\d{2}$').hasMatch(periodId)) {
    int year = int.parse(periodId.substring(0, 4));
    int week = int.parse(periodId.substring(5, 7));
    return _getPreviousWeek(year, week);
  } else if (RegExp(r'^\d{4}Q\d$').hasMatch(periodId)) {
    int year = int.parse(periodId.substring(0, 4));
    int quarter = int.parse(periodId.substring(5, 6));
    return _getPreviousQuarter(year, quarter);
  } else {
    throw ArgumentError("Invalid period ID format");
  }
}
