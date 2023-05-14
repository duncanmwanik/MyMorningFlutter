import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mymorning/variables/global_variables.dart';
import 'package:mymorning/helpers/alarms_helper.dart';
import 'package:mymorning/models/alarm_model.dart';
import 'package:mymorning/state/global_state.dart';
import '../../../../widgets/alarm_widget.dart';

Widget noAlarmBox(String text) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: w * 0.1, vertical: 10),
    padding: EdgeInsets.symmetric(vertical: 20),
    decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.all(Radius.circular(15))),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w600),
    ),
  );
}

Widget alarmList(BuildContext context) {
  return bleWatch.connected
      ? Consumer<GlobalModel>(builder: (context, global, child) {
          if (global.alarmMap[global.selectedDate] != null) {
            if (global.alarmMap[global.selectedDate]!.isNotEmpty) {
              List<String> sortedList = sortAlarmsByTime(global.alarmMap[global.selectedDate]!);

              return ListView.builder(
                  itemCount: sortedList.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    String alarm = sortedList[index];
                    int hour = int.parse(alarm.substring(6).split(":")[0]);
                    int min = int.parse(alarm.substring(6).split(":")[1]);
                    //[ alarmActive-alarmRepeat-vibrationPattern-vibrationStrength-snoozeOn-snoozeMin-time ]
                    return AlarmWidget(
                      day: global.selectedDate,
                      alarm: AlarmObject(
                          alarmActive: int.parse(alarm[0]),
                          alarmRepeat: int.parse(alarm[1]),
                          vibrationPattern: int.parse(alarm[2]),
                          vibrationStrength: int.parse(alarm[3]),
                          snoozeOn: int.parse(alarm[4]),
                          snoozeMin: int.parse(alarm[5]),
                          alarmTime: TimeOfDay(hour: hour, minute: min),
                          alarmName: getAlarmNameFromMap(
                            AlarmObject(
                                alarmActive: int.parse(alarm[0]),
                                alarmRepeat: int.parse(alarm[1]),
                                vibrationPattern: int.parse(alarm[2]),
                                vibrationStrength: int.parse(alarm[3]),
                                snoozeOn: int.parse(alarm[4]),
                                snoozeMin: int.parse(alarm[5]),
                                alarmTime: TimeOfDay(hour: hour, minute: min),
                                alarmName: "My Alarm"),
                          )),
                    );
                  });
            } else {
              return noAlarmBox('No alarms set today');
            }
          } else {
            return noAlarmBox('No alarms set today');
          }
        })
      : noAlarmBox('No device connected');
}
