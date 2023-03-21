import 'package:flutter/material.dart';

import '../../../../_variables/date_time_variables.dart';
import '../../../../_variables/global_variables.dart';
import '../../../../models/alarm_model.dart';
import '../../alarms/add_alarm_screen.dart';

Widget addAlarmButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddAlarmScreen(
                      selectedDays: [globalWatch.selectedDate],
                      alarm: AlarmObject(
                          alarmTime: TimeOfDay.now(),
                          alarmActive: 1,
                          alarmRepeat: 1,
                          vibrationPattern: 0,
                          vibrationStrength: 9,
                          snoozeOn: 0,
                          snoozeMin: 1,
                          alarmName: "My Alarm"))),
            );
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white70,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  "${weekDaysList[globalWatch.selectedDate].dayName}'s Alarms",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w700),
                ),
              ),
              Icon(
                Icons.add_circle,
                color: Colors.green,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
