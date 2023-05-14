import 'package:flutter/material.dart';
import 'package:flutter_spinner_picker/flutter_spinner_picker.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../../widgets/back_button.dart';
import '../../variables/constant_variables.dart';
import '../../variables/global_variables.dart';
import '../../config/theme/theme.dart';
import '../../helpers/alarms_helper.dart';
import '../../models/alarm_model.dart';

// ignore: must_be_immutable
class EditAlarmScreen extends StatefulWidget {
  EditAlarmScreen({required this.day, required this.alarm, required this.prevAlarm, super.key});

  int day;
  AlarmObject alarm;
  AlarmObject prevAlarm;

  @override
  State<EditAlarmScreen> createState() => _EditAlarmScreenState();
}

class _EditAlarmScreenState extends State<EditAlarmScreen> {
  DateTime selectedtime = DateTime.now();
  TextEditingController? nameText = TextEditingController();

  @override
  initState() {
    setState(() {
      nameText?.text = widget.alarm.alarmName;
      DateTime date = DateTime.now();
      selectedtime = DateTime(date.year, date.month, date.day, widget.alarm.alarmTime.hour, widget.alarm.alarmTime.minute);
    });
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

  Widget textTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w700),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            "Edit your alarm",
            style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // ***************** Alarm Name *************************
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
              // **************************************************
              // ********** TIME **********
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.all(Radius.circular(40))),
                child: Column(
                  children: [
                    textTitle("2. Change the Time"),
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
              ), // ********** Repeat Alarm **********
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                padding: EdgeInsets.only(top: 10, bottom: 15, left: 10, right: 10),
                decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.all(Radius.circular(40))),
                child: Column(
                  children: [
                    textTitle("3. Repeat Alarm"),
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

              // ********** VIBRATION PATTERN **********
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                padding: EdgeInsets.only(top: 10, bottom: 15, left: 10, right: 10),
                decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.all(Radius.circular(40))),
                child: Column(
                  children: [
                    textTitle("4. Vibration Pattern"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [for (int i = 0; i < 4; i++) _vibrationPatternChoice(i)],
                    ),
                  ],
                ),
              ),

              // ********** VIBRATION STRENGTH **********
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.all(Radius.circular(40))),
                child: Column(
                  children: [
                    textTitle("5. Vibration Strength"),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Weak',
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

              // **************************************************
              // ********** SNOOZE **********
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.all(Radius.circular(40))),
                child: Column(
                  children: [
                    textTitle("6. Snooze"),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        "( We recommend no snooze, as snoozing is a false wake up )",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
                      ),
                    ),
                    // ******* Snooze Buttons
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
                    SizedBox(
                      height: 15,
                    ),
                    // ***** Snooze Minutes Picker
                    Visibility(
                      visible: widget.alarm.snoozeOn == 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NumberPicker(
                            itemHeight: 40,
                            textStyle: TextStyle(fontSize: 24, color: Colors.black26, fontWeight: FontWeight.w600),
                            selectedTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
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

              // -------------------- Submit button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await editAlarm(context, day: widget.day, prevAlarm: widget.prevAlarm, alarm: widget.alarm, popScreen: true);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          fixedSize: Size(w * 0.4, h * 0.06),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                      child: Text(
                        'Save',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w700),
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
