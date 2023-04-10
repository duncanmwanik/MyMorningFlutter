// list of days of the week objects
import '../models/dates_model.dart';

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
const List<String> months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

// converts 24hrs ti 12 hour clock version
const Map<int, int> hours24to12 = {0: 12, 13: 1, 14: 2, 15: 3, 16: 4, 17: 5, 18: 6, 19: 7, 20: 8, 21: 9, 22: 10, 23: 11};

Map<int, int> hours12to24 = hours24to12.map((k, v) => MapEntry(v, k));
