import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../logic/alarms_logic.dart';
import '../../logic/datetime_logic.dart';
import '../../_variables/global_variables.dart';
import '../../models/alarm_model.dart';
import '../../models/vibration_model.dart';
import '../theme/theme.dart';
import '../screens/alarms/alarm_overview_screen.dart';

// ignore: must_be_immutable
class AlarmWidget extends StatefulWidget {
  AlarmWidget({required this.day, required this.alarm, super.key});

  int day;
  AlarmObject alarm;

  @override
  State<AlarmWidget> createState() => _AlarmWidgetState();
}

class _AlarmWidgetState extends State<AlarmWidget> {
  late AlarmObject prevAlarm;
  @override
  initState() {
    super.initState();
    setState(() {
      prevAlarm = widget.alarm;
    });
  }

  Widget _vibrationPatternChoice(int choice) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(vibrationPatternList[choice].patternImage),
          fit: BoxFit.cover,
        ),
        shape: BoxShape.circle,
        border: Border.all(
          width: 1,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AlarmOverviewScreen(
                  day: widget.day,
                  alarm: AlarmObject(
                      alarmTime: widget.alarm.alarmTime,
                      alarmActive: widget.alarm.alarmActive,
                      alarmRepeat: widget.alarm.alarmRepeat,
                      vibrationPattern: widget.alarm.vibrationPattern,
                      vibrationStrength: widget.alarm.vibrationStrength,
                      snoozeOn: widget.alarm.snoozeOn,
                      snoozeMin: widget.alarm.snoozeMin,
                      alarmName: widget.alarm.alarmName))),
        );
      },
      onLongPress: () => deleteAlarm(
          context: context,
          day: globalWatch.selectedDate,
          alarm: AlarmObject(
              alarmTime: widget.alarm.alarmTime,
              alarmActive: widget.alarm.alarmActive,
              alarmRepeat: widget.alarm.alarmRepeat,
              vibrationPattern: widget.alarm.vibrationPattern,
              vibrationStrength: widget.alarm.vibrationStrength,
              snoozeOn: widget.alarm.snoozeOn,
              snoozeMin: widget.alarm.snoozeMin,
              alarmName: widget.alarm.alarmName)),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 7),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage((widget.alarm.alarmTime.hour) >= 12 ? "assets/images/night2.png" : "assets/images/day2.png"),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.all(Radius.circular(40)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 1,
              blurRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 1, vertical: 5),
              child: Text(
                widget.alarm.alarmName,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: Text(
                    get24to12(widget.alarm.alarmTime),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 21, color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                    width: 35,
                    height: 35,
                    child: Image(
                        image: AssetImage(
                            (widget.alarm.snoozeOn == 1) ? 'assets/images/snooze_on.png' : 'assets/images/snooze_off.png'))),
                CupertinoSwitch(
                    value: widget.alarm.alarmActive == 1 ? true : false,
                    onChanged: ((value) async {
                      setState(() {
                        if (value) {
                          widget.alarm.alarmActive = 1;
                        } else {
                          widget.alarm.alarmActive = 0;
                        }
                      });

                      await editAlarm(context, day: widget.day, prevAlarm: prevAlarm, alarm: widget.alarm);
                      await Future.delayed(Duration(milliseconds: 500), () {});
                      await getAlarmListFromDevice();
                    })),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _vibrationPatternChoice(widget.alarm.vibrationPattern),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    padding: EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(color: Colors.white54, borderRadius: BorderRadius.all(Radius.circular(40))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Weak',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            // fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Flexible(
                          child: Slider(
                            label: "Strength",
                            min: 1,
                            max: 9,
                            value: widget.alarm.vibrationStrength.toDouble(),
                            thumbColor: Colors.orange,
                            activeColor: primaryColor,
                            onChanged: (value) {
                              // setState(() {
                              //   widget.alarm.vibrationStrength = value.toInt();
                              // });
                            },
                            onChangeEnd: (value) async {
                              // setState(() {
                              //   widget.alarm.vibrationStrength = value.toInt();
                              // });
                              // await editAlarm(
                              //   day: widget.alarm.day,
                              //   alarmActive: widget.alarm.alarmActive,
                              //   alarmTime: widget.alarm.alarmTime,
                              //   alarmName: widget.alarm.alarmName,
                              //   alarmRepeat: widget.alarm.alarmRepeat,
                              //   vibrationPattern: widget.alarm.vibrationPattern,
                              //   vibrationStrength: widget.alarm.vibrationStrength,
                              //   snoozeOn: widget.alarm.snoozeOn,
                              //   snoozeMin: widget.alarm.snoozeMin,
                              //   prevTime: widget.alarm.alarmTime,
                              // );
                              // // await Future.delayed(Duration(milliseconds: 200), () {});
                              // await getAlarmList();
                            },
                          ),
                        ),
                        Text(
                          'Strong',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            // fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
