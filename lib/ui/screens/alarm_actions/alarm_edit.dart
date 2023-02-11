import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:numberpicker/numberpicker.dart';
import '../../../methods/ble.dart';
import '../../../methods/globals.dart';
import '../../../models/vibration.dart';
import '../../theme/theme.dart';
import '../../widgets/back_button.dart';
import '../../widgets/toast.dart';
import '../home.dart';

// ignore: must_be_immutable
class EditAlarmScreen extends StatefulWidget {
  EditAlarmScreen(
      {required this.day,
      required this.alarmTime,
      required this.alarmName,
      required this.alarmActive,
      required this.alarmRepeat,
      required this.vibrationPattern,
      required this.vibrationStrength,
      required this.snoozeOn,
      required this.snoozeMin,
      super.key});

  int day;
  TimeOfDay alarmTime;
  String alarmName;
  int alarmActive;
  int alarmRepeat;
  int vibrationPattern;
  int vibrationStrength;
  int snoozeOn;
  int snoozeMin;

  @override
  State<EditAlarmScreen> createState() => _EditAlarmScreenState();
}

class _EditAlarmScreenState extends State<EditAlarmScreen> {
  DateTime selectedtime = DateTime.now();
  TextEditingController? nameText = TextEditingController();
  late TimeOfDay prevTime;

  @override
  initState() {
    setState(() {
      nameText?.text = 'My Alarm';
      prevTime = widget.alarmTime;
      DateTime date = DateTime.now();
      selectedtime = DateTime(date.year, date.month, date.day, widget.alarmTime.hour, widget.alarmTime.minute);
    });
    super.initState();
  }

  Widget _vibrationPatternChoice(int choice) {
    return GestureDetector(
      onTap: (() {
        setState(() {
          widget.vibrationPattern = choice;
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
            width: choice == widget.vibrationPattern ? 3 : 0.5,
            color: choice == widget.vibrationPattern ? primaryColor : Colors.black,
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
                        TimePickerSpinner(
                          time: selectedtime,
                          is24HourMode: false,
                          normalTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black26),
                          highlightedTextStyle:
                              TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black),
                          spacing: 20,
                          itemHeight: 50,
                          isForce2Digits: true,
                          onTimeChange: (time) {
                            setState(() {
                              selectedtime = time;
                              widget.alarmTime = TimeOfDay.fromDateTime(time);
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
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              widget.alarmRepeat = 1;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: widget.alarmRepeat == 1 ? Colors.orange : Colors.white,
                              // fixedSize: Size(w * 0.3, h * 0.05),
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
                              widget.alarmRepeat = 0;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: widget.alarmRepeat == 0 ? Colors.orange : Colors.white,
                              // fixedSize: Size(w * 0.3, h * 0.05),
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
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(
                            child: Slider(
                              label: "Select Strength",
                              thumbColor: Colors.orange,
                              activeColor: primaryColor,
                              value: widget.vibrationStrength.toDouble(),
                              onChanged: (value) {
                                setState(() {
                                  widget.vibrationStrength = value.toInt();
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
                              fontSize: 15,
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
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                    // ******* Snooze Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              widget.snoozeOn = 1;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: widget.snoozeOn == 1 ? Colors.orange : Colors.white,
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
                              widget.snoozeOn = 0;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: widget.snoozeOn == 0 ? Colors.orange : Colors.white,
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
                      visible: widget.snoozeOn == 1,
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
                            value: widget.snoozeMin,
                            minValue: 1,
                            maxValue: 5,
                            onChanged: (value) => setState(() => widget.snoozeMin = value),
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

              // **************************************************
              // ********** SUBMIT BUTTON **********
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (bleWatch.btState) {
                          if (bleWatch.connected) {
                            await globalWatch.showLoadingScreen(true);

                            bool success = await editAlarm(
                              day: widget.day,
                              prevTime: prevTime,
                              alarmTime: widget.alarmTime,
                              alarmName: nameText!.text.isEmpty ? 'My Alarm' : nameText!.text,
                              alarmActive: widget.alarmActive,
                              alarmRepeat: widget.alarmRepeat,
                              vibrationPattern: widget.vibrationPattern,
                              vibrationStrength: widget.vibrationStrength,
                              snoozeOn: widget.snoozeOn,
                              snoozeMin: widget.snoozeMin,
                            );

                            if (success) {
                              await Future.delayed(Duration(milliseconds: 500), () {});
                              await getAlarmList();

                              await globalWatch.showLoadingScreen(false);

                              Navigator.pushAndRemoveUntil<dynamic>(
                                context,
                                MaterialPageRoute<dynamic>(
                                  builder: (BuildContext context) => HomeScreen(),
                                ),
                                (route) => false,
                              );
                            } else {
                              toast(0, "Failed to edit alarm!");
                            }
                          } else {
                            toast(0, "No device connected!");
                          }
                        } else {
                          toast(0, "Bluetooth is off");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          fixedSize: Size(w * 0.3, h * 0.05),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                      child: Text(
                        'Edit',
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
