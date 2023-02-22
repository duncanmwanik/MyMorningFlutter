// --------------------------------- DATE & TIME ---------------------------------
// all date & time variables, methods and providers

import 'package:flutter/material.dart';

import '../models/dates.dart';
import 'globals.dart';

// list of days of the week objects
List<DayObject> weekDaysList = [
  const DayObject(dayNumber: 0, dayName: 'Sunday', dayShortName: 'S'),
  const DayObject(dayNumber: 1, dayName: 'Monday', dayShortName: 'M'),
  const DayObject(dayNumber: 2, dayName: 'Tuesday', dayShortName: 'T'),
  const DayObject(dayNumber: 3, dayName: 'Wednesday', dayShortName: 'W'),
  const DayObject(dayNumber: 4, dayName: 'Thursday', dayShortName: 'T'),
  const DayObject(dayNumber: 5, dayName: 'Friday', dayShortName: 'F'),
  const DayObject(dayNumber: 6, dayName: 'Saturday', dayShortName: 'S'),
];

// all months
List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

// converts 24hrs ti 12 hour clock version
Map<int, int> hours24to12 = {0: 12, 13: 1, 14: 2, 15: 3, 16: 4, 17: 5, 18: 6, 19: 7, 20: 8, 21: 9, 22: 10, 23: 11};

Map<int, int> hours12to24 = hours24to12.map((k, v) => MapEntry(v, k));

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
  int dayNo = globalWatch.currentWeekDates[globalWatch.selectedDate].weekday == 7 ? 0 : globalWatch.currentWeekDates[globalWatch.selectedDate].weekday;
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
