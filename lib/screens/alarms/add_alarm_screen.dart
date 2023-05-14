import 'package:flutter/material.dart';
import 'package:flutter_spinner_picker/flutter_spinner_picker.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../variables/constant_variables.dart';
import '../../variables/date_time_variables.dart';
import '../../helpers/alarms_helper.dart';
import '../../helpers/datetime_helper.dart';
import '../../variables/global_variables.dart';
import '../../models/alarm_model.dart';
import '../../models/dates_model.dart';
import '../../config/theme/theme.dart';
import '../../../widgets/back_button.dart';
import '../../../widgets/bottom_navbar.dart';
import '../../../widgets/toast.dart';
import '../home/home_screen.dart';

// ignore: must_be_immutable
class AddAlarmScreen extends StatefulWidget {
  AddAlarmScreen({required this.selectedDays, required this.alarm, super.key});

  List<int> selectedDays;
  AlarmObject alarm;

  @override
  State<AddAlarmScreen> createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  String selectMode = 'none';
  DateTime selectedtime = DateTime.now();
  // DateTime selectedtime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 12, 44);
  TextEditingController? nameText = TextEditingController(text: "My Alarm");

  @override
  initState() {
    super.initState();
  }

  Widget _vibrationPatternChoice(int choice) {
    return GestureDetector(
      onTap: (() {
        setState(() {
          widget.alarm.vibrationPattern = choice;
        });
      }),
      child: Container(
        width: w * 0.15,
        height: w * 0.15,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(vibrationPatternList[choice].patternImage),
            fit: BoxFit.cover,
          ),
          shape: BoxShape.circle,
          border: Border.all(
            width: choice == widget.alarm.vibrationPattern ? 3 : 0.5,
            color: choice == widget.alarm.vibrationPattern ? primaryColor : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _dayWidget(DayObject day) {
    return GestureDetector(
      onTap: (() {
        setState(() {
          widget.selectedDays.contains(day.dayNumber) ? widget.selectedDays.remove(day.dayNumber) : widget.selectedDays.add(day.dayNumber);
          selectMode = 'none';
          widget.selectedDays.sort();
        });
      }),
      child: Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: widget.selectedDays.contains(day.dayNumber) ? primaryColor.withOpacity(0.5) : Colors.white,
          shape: BoxShape.circle,
        ),
        child: SizedBox(
          width: 22,
          height: 22,
          child: Center(
              child: Text(
            day.dayShortName,
            style: TextStyle(fontWeight: FontWeight.w700),
          )),
        ),
      ),
    );
  }

  Widget _dayMode(String mode) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectMode = mode;

          if (mode == 'Everyday') {
            widget.selectedDays.clear();
            widget.selectedDays.addAll([0, 1, 2, 3, 4, 5, 6]);
            widget.selectedDays.sort();
          }
          if (mode == 'Weekdays') {
            widget.selectedDays.clear();
            widget.selectedDays.addAll([1, 2, 3, 4, 5]);
            widget.selectedDays.sort();
          }
          if (mode == 'Weekends') {
            widget.selectedDays.clear();
            widget.selectedDays.addAll([0, 6]);
            widget.selectedDays.sort();
          }
        });
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: selectMode == mode ? Colors.grey : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          )),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(
          mode,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget textTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 19, color: Colors.black, fontWeight: FontWeight.w700),
      ),
    );
  }

  Future<bool> onWillPop() async {
    await globalWatch.updateSelectedTab(0);
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => HomeScreen(),
      ),
      (route) => false,
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/back.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: customBackButton(context, primaryColor),
            centerTitle: true,
            title: Text(
              getWeekRange(),
              style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          bottomNavigationBar: bottomNavbar(context, false),
          body: ListView(
            shrinkWrap: true,
            children: [
              // -------------------- Name --------------------
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.all(Radius.circular(40))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    textTitle("1. Alarm Name"),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        border: Border.all(
                          width: 0.5,
                          color: primaryColor,
                        ),
                      ),
                      child: TextField(
                        controller: nameText,
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            widget.alarm.alarmName = value.isEmpty ? 'My Alarm' : value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // -------------------- Days --------------------
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.all(Radius.circular(40))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    textTitle("2. Choose A Day for Alarm"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(40))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (int i = 0; i < 7; i++) _dayWidget(weekDaysList[i]),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 2,
                      children: [
                        _dayMode('Everyday'),
                        _dayMode('Weekdays'),
                        _dayMode('Weekends'),
                      ],
                    ),
                  ],
                ),
              ),

              // -------------------- Time --------------------
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.all(Radius.circular(40))),
                child: Column(
                  children: [
                    textTitle("3. Set your Time"),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          children: [
                            Divider(
                              thickness: 3,
                            ),
                            SizedBox(
                              height: 35,
                            ),
                            Divider(
                              thickness: 3,
                            )
                          ],
                        ),
                        FlutterSpinner(
                          height: 150,
                          width: 200,
                          selectedTime: selectedtime,
                          onTimeChange: (date) {
                            setState(() {
                              selectedtime = date;
                              widget.alarm.alarmTime = TimeOfDay.fromDateTime(date);
                            });
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        'Make sure you double check AM/PM',
                        textAlign: TextAlign.center,
                        style: alarmAddDescriptions,
                      ),
                    ),
                  ],
                ),
              ),

              // -------------------- Repeat --------------------

              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                padding: EdgeInsets.only(top: 10, bottom: 15, left: 10, right: 10),
                decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.all(Radius.circular(40))),
                child: Column(
                  children: [
                    textTitle("4. Repeat Alarm"),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        "Repeats the alarm every week on the choosen days and time",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              widget.alarm.alarmRepeat = 1;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: widget.alarm.alarmRepeat == 1 ? Colors.orange : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              )),
                          child: Text(
                            'Yes',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              widget.alarm.alarmRepeat = 0;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: widget.alarm.alarmRepeat == 0 ? Colors.orange : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              )),
                          child: Text(
                            'No',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // -------------------- Vibration Pattern --------------------

              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                padding: EdgeInsets.only(top: 10, bottom: 15, left: 10, right: 10),
                decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.all(Radius.circular(40))),
                child: Column(
                  children: [
                    textTitle("5. Vibration Pattern"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [for (int i = 0; i < 4; i++) _vibrationPatternChoice(i)],
                    ),
                  ],
                ),
              ),

              // -------------------- Vibration Strength --------------------

              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.all(Radius.circular(40))),
                child: Column(
                  children: [
                    textTitle("6. Vibration Strength"),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            '  Weak',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(
                            child: Slider(
                              label: "Select Strength",
                              thumbColor: Colors.orange,
                              activeColor: primaryColor,
                              value: widget.alarm.vibrationStrength.toDouble(),
                              onChanged: (value) {
                                setState(() {
                                  widget.alarm.vibrationStrength = value.toInt();
                                });
                              },
                              min: 1,
                              max: 9,
                            ),
                          ),
                          Text(
                            'Strong',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // -------------------- Snooze --------------------
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.all(Radius.circular(40))),
                child: Column(
                  children: [
                    textTitle("7. Snooze"),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        "( We recommend no snooze, as snoozing is a false wake up )",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                      ),
                    ),
                    // ---------- Snooze Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              widget.alarm.snoozeOn = 1;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: widget.alarm.snoozeOn == 1 ? Colors.orange : Colors.white,
                              fixedSize: Size(w * 0.3, h * 0.05),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              )),
                          child: Text(
                            'Yes',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              widget.alarm.snoozeOn = 0;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: widget.alarm.snoozeOn == 0 ? Colors.orange : Colors.white,
                              fixedSize: Size(w * 0.3, h * 0.05),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          child: Text(
                            'No',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    // ---------- Snooze Minutes Picker
                    Visibility(
                      visible: widget.alarm.snoozeOn == 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NumberPicker(
                            itemHeight: 40,
                            textStyle: TextStyle(fontSize: 24, color: Colors.black26, fontWeight: FontWeight.w500),
                            selectedTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(width: 2),
                                bottom: BorderSide(width: 2),
                              ),
                            ),
                            value: widget.alarm.snoozeMin,
                            minValue: 1,
                            maxValue: 5,
                            onChanged: (value) => setState(() => widget.alarm.snoozeMin = value),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'minutes',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // -------------------- Submit Button --------------------
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (widget.selectedDays.isNotEmpty) {
                          await addAlarm(context, selectedDays: widget.selectedDays, alarm: widget.alarm);
                        } else {
                          toast(0, "Select at least one day!");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          fixedSize: Size(w * 0.4, h * 0.06),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                      child: Text(
                        'Create',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: h * 0.01,
              )
            ],
          ),
        ),
      ),
    );
  }
}
