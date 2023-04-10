//
//
// date-time functions
//
//

import 'package:flutter/material.dart';

import '../_variables/date_time_variables.dart';
import '../_variables/global_variables.dart';

String get24to12(TimeOfDay time) {
  String hour = ((time.hour > 12 || time.hour == 0) ? hours24to12[time.hour] : time.hour).toString();
  String minute = time.minute.toString();
  String period = time.hour > 12 ? 'PM' : 'AM';
  hour = hour.length == 2 ? hour : '0$hour';
  minute = minute.length == 2 ? minute : '0$minute';

  return '$hour:$minute $period';
}

String getWeekRange() {
  String month1 = months[globalWatch.currentWeekDates[0].month - 1];
  String month2 = months[globalWatch.currentWeekDates[6].month - 1];
  int day1 = globalWatch.currentWeekDates[0].day;
  int day2 = globalWatch.currentWeekDates[6].day;
  if (month1 == month2) {
    return '$month1 $day1-$day2';
  } else {
    return '$month1 $day1 - $month2 $day2';
  }
}

String getWeekDay() {
  int dayNo = globalWatch.currentWeekDates[globalWatch.selectedDate].weekday == 7
      ? 0
      : globalWatch.currentWeekDates[globalWatch.selectedDate].weekday;
  String day = weekDaysList[dayNo].dayName;
  String month = months[globalWatch.currentWeekDates[globalWatch.selectedDate].month - 1];
  int date = globalWatch.currentWeekDates[globalWatch.selectedDate].day;
  return '$day, $month $date';
}

List<DateTime> getCurrentWeekDates() {
  int today = DateTime.now().weekday;

  if (today == 1) {
    return [
      DateTime.now().subtract(Duration(days: 1)),
      DateTime.now(),
      DateTime.now().add(Duration(days: 1)),
      DateTime.now().add(Duration(days: 2)),
      DateTime.now().add(Duration(days: 3)),
      DateTime.now().add(Duration(days: 4)),
      DateTime.now().add(Duration(days: 5)),
    ];
  }
  if (today == 2) {
    return [
      DateTime.now().subtract(Duration(days: 2)),
      DateTime.now().subtract(Duration(days: 1)),
      DateTime.now(),
      DateTime.now().add(Duration(days: 1)),
      DateTime.now().add(Duration(days: 2)),
      DateTime.now().add(Duration(days: 3)),
      DateTime.now().add(Duration(days: 4)),
    ];
  }
  if (today == 3) {
    return [
      DateTime.now().subtract(Duration(days: 3)),
      DateTime.now().subtract(Duration(days: 2)),
      DateTime.now().subtract(Duration(days: 1)),
      DateTime.now(),
      DateTime.now().add(Duration(days: 1)),
      DateTime.now().add(Duration(days: 2)),
      DateTime.now().add(Duration(days: 3)),
    ];
  }
  if (today == 4) {
    return [
      DateTime.now().subtract(Duration(days: 4)),
      DateTime.now().subtract(Duration(days: 3)),
      DateTime.now().subtract(Duration(days: 2)),
      DateTime.now().subtract(Duration(days: 1)),
      DateTime.now(),
      DateTime.now().add(Duration(days: 1)),
      DateTime.now().add(Duration(days: 2)),
    ];
  }
  if (today == 5) {
    return [
      DateTime.now().subtract(Duration(days: 5)),
      DateTime.now().subtract(Duration(days: 4)),
      DateTime.now().subtract(Duration(days: 3)),
      DateTime.now().subtract(Duration(days: 2)),
      DateTime.now().subtract(Duration(days: 1)),
      DateTime.now(),
      DateTime.now().add(Duration(days: 1)),
    ];
  }
  if (today == 6) {
    return [
      DateTime.now().subtract(Duration(days: 6)),
      DateTime.now().subtract(Duration(days: 5)),
      DateTime.now().subtract(Duration(days: 4)),
      DateTime.now().subtract(Duration(days: 3)),
      DateTime.now().subtract(Duration(days: 2)),
      DateTime.now().subtract(Duration(days: 1)),
      DateTime.now(),
    ];
  }
  if (today == 7) {
    return [
      DateTime.now(),
      DateTime.now().add(Duration(days: 1)),
      DateTime.now().add(Duration(days: 2)),
      DateTime.now().add(Duration(days: 3)),
      DateTime.now().add(Duration(days: 4)),
      DateTime.now().add(Duration(days: 5)),
      DateTime.now().add(Duration(days: 6)),
    ];
  }

  return [];
}
