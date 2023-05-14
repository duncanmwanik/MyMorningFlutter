import 'package:flutter/material.dart';

class AlarmObject {
  int alarmActive;
  int alarmRepeat;
  int vibrationPattern;
  int vibrationStrength;
  int snoozeOn;
  int snoozeMin;
  TimeOfDay alarmTime;
  String alarmName;

  AlarmObject({
    required this.alarmActive,
    required this.alarmRepeat,
    required this.vibrationPattern,
    required this.vibrationStrength,
    required this.snoozeOn,
    required this.snoozeMin,
    required this.alarmTime,
    required this.alarmName,
  });
}
