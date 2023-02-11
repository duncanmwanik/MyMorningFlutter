import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../methods/ble.dart';
import '../../methods/datetime.dart';
import '../../methods/globals.dart';
import '../../models/vibration.dart';
import '../theme/theme.dart';
import '../screens/alarm_actions/alarm_overview.dart';
import 'confirm_delete_dialog.dart';

// ignore: must_be_immutable
class AlarmWidget extends StatefulWidget {
  AlarmWidget(
      {required this.day,
      required this.alarmTime,
      required this.alarmActive,
      required this.alarmRepeat,
      required this.vibrationPattern,
      required this.vibrationStrength,
      required this.snoozeOn,
      required this.snoozeMin,
      required this.alarmName,
      super.key});

  int day;
  int alarmActive;
  int alarmRepeat;
  int vibrationPattern;
  int vibrationStrength;
  int snoozeOn;
  int snoozeMin;
  TimeOfDay alarmTime;
  String alarmName;

  @override
  State<AlarmWidget> createState() => _AlarmWidgetState();
}

class _AlarmWidgetState extends State<AlarmWidget> {
  @override
  initState() {
    super.initState();
    setState(() {});
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
                  alarmTime: widget.alarmTime,
                  alarmActive: widget.alarmActive,
                  alarmRepeat: widget.alarmRepeat,
                  vibrationPattern: widget.vibrationPattern,
                  vibrationStrength: widget.vibrationStrength,
                  snoozeOn: widget.snoozeOn,
                  snoozeMin: widget.snoozeMin,
                  alarmName: widget.alarmName)),
        );
      },
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.horizontal,
        onDismissed: (DismissDirection direction) async {
          await deleteAlarm(day: globalWatch.selectedDate, alarmTime: widget.alarmTime);
          await Future.delayed(Duration(milliseconds: 500), () {});
          await getAlarmList();
        },
        background: const ColoredBox(
          color: Colors.black12,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
                size: 35,
              ),
            ),
          ),
        ),
        confirmDismiss: (DismissDirection direction) async {
          final confirmed = await showConfirmDeletionDialog(context);
          return confirmed;
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 7),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage((widget.alarmTime.hour) >= 12 ? "assets/images/night2.png" : "assets/images/day2.png"),
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
                  widget.alarmName,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: Text(
                      get24to12(widget.alarmTime),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 21, color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                      width: 35,
                      height: 35,
                      child: Image(
                          image: AssetImage((widget.snoozeOn == 1)
                              ? 'assets/images/snooze_on.png'
                              : 'assets/images/snooze_off.png'))),
                  CupertinoSwitch(
                      value: widget.alarmActive == 1 ? true : false,
                      onChanged: ((value) async {
                        setState(() {
                          if (value) {
                            widget.alarmActive = 1;
                          } else {
                            widget.alarmActive = 0;
                          }
                        });

                        await editAlarm(
                          day: widget.day,
                          alarmActive: value ? 1 : 0,
                          alarmTime: widget.alarmTime,
                          alarmName: widget.alarmName,
                          alarmRepeat: widget.alarmRepeat,
                          vibrationPattern: widget.vibrationPattern,
                          vibrationStrength: widget.vibrationStrength,
                          snoozeOn: widget.snoozeOn,
                          snoozeMin: widget.snoozeMin,
                          prevTime: widget.alarmTime,
                        );
                        await Future.delayed(Duration(milliseconds: 500), () {});
                        await getAlarmList();
                      })),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _vibrationPatternChoice(widget.vibrationPattern),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration:
                          BoxDecoration(color: Colors.white54, borderRadius: BorderRadius.all(Radius.circular(40))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Weak',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Flexible(
                            child: Slider(
                              label: "Strength",
                              min: 1,
                              max: 9,
                              value: widget.vibrationStrength.toDouble(),
                              thumbColor: Colors.orange,
                              activeColor: primaryColor,
                              onChanged: (value) {
                                // setState(() {
                                //   widget.vibrationStrength = value.toInt();
                                // });
                              },
                              onChangeEnd: (value) async {
                                // setState(() {
                                //   widget.vibrationStrength = value.toInt();
                                // });
                                // await editAlarm(
                                //   day: widget.day,
                                //   alarmActive: widget.alarmActive,
                                //   alarmTime: widget.alarmTime,
                                //   alarmName: widget.alarmName,
                                //   alarmRepeat: widget.alarmRepeat,
                                //   vibrationPattern: widget.vibrationPattern,
                                //   vibrationStrength: widget.vibrationStrength,
                                //   snoozeOn: widget.snoozeOn,
                                //   snoozeMin: widget.snoozeMin,
                                //   prevTime: widget.alarmTime,
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
                              fontSize: 14,
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
      ),
    );
  }
}
