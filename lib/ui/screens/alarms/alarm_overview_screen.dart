import 'package:flutter/material.dart';
import '../../../logic/alarms_logic.dart';
import '../../../logic/datetime_logic.dart';
import '../../../_variables/global_variables.dart';
import '../../../models/alarm_model.dart';
import '../../../models/vibration_model.dart';
import '../../theme/theme.dart';
import '../../widgets/back_button.dart';
import '../../widgets/change_name_dialog.dart';
import 'edit_alarm_screen.dart';

// ignore: must_be_immutable
class AlarmOverviewScreen extends StatefulWidget {
  AlarmOverviewScreen({required this.day, required this.alarm, super.key});

  int day;
  AlarmObject alarm;

  @override
  State<AlarmOverviewScreen> createState() => _AlarmOverviewScreenState();
}

class _AlarmOverviewScreenState extends State<AlarmOverviewScreen> {
  Widget _vibrationPatternChoice(int choice) {
    return Container(
      width: w * 0.1,
      height: w * 0.1,
      margin: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(vibrationPatternList[choice].patternImage),
          fit: BoxFit.cover,
        ),
        color: Colors.grey.shade300,
        shape: BoxShape.circle,
        border: Border.all(
          width: 1.5,
          color: Colors.grey.shade300,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
          ),
        ],
      ),
    );
  }

  Widget textTitle(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      overflow: TextOverflow.clip,
      style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
    );
  }

  Widget actionButton(BuildContext context, String label, GestureTapCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.transparent,
        side: BorderSide(width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.black, fontWeight: FontWeight.w600),
        ),
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
          leading: customBackButton(context, Colors.black),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            // **************************************************
            // ********** Alarn Name Edit *********
            TextButton(
              onPressed: () async {
                TextEditingController? textController = TextEditingController(text: widget.alarm.alarmName);

                await changeNameDialog(
                    context: context,
                    description: "Edit alarm name",
                    textController: textController,
                    maxLength: 50,
                    onTap: () async {
                      await globalWatch.deleteAlarmName(alarm: widget.alarm);
                      setState(() {
                        widget.alarm.alarmName = textController.text;
                      });
                      await globalWatch.addAlarmName(alarm: widget.alarm);
                      print(":::::::::::NamesMap>> ${globalWatch.alarmNamesMap.toString()}");
                      Navigator.pop(context, true);
                    });

                // print(":::::::::::New>> ${textController.text}");
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      widget.alarm.alarmName.isEmpty ? "No alarm Name" : widget.alarm.alarmName,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.edit,
                    color: Colors.black54,
                  )
                ],
              ),
            ),
            // **************************************************
            // ********** Alarn Details **********
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                        AssetImage((widget.alarm.alarmTime.hour) >= 12 ? "assets/images/night2.png" : "assets/images/day2.png"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(40))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //***** Alarm Time
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              textTitle("Alarm Time"),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                get24to12(widget.alarm.alarmTime),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                        //***** Vibration Pattern
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              textTitle("Vibration Pattern"),
                              _vibrationPatternChoice(widget.alarm.vibrationPattern),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //***** Vibration strength
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              textTitle("Vibration Strength"),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                // margin: EdgeInsets.only(left: 10),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration:
                                    BoxDecoration(color: Colors.white54, borderRadius: BorderRadius.all(Radius.circular(40))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        'Weak',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 3,
                                      child: Theme(
                                        data: Theme.of(context).copyWith(),
                                        child: Slider(
                                          label: "Select Strength",
                                          value: widget.alarm.vibrationStrength.toDouble(),
                                          thumbColor: Colors.orange,
                                          activeColor: primaryColor,
                                          onChanged: (value) {},
                                          min: 1,
                                          max: 9,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        'Strong',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        //***** Snooze
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              textTitle("Snooze"),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: Image(
                                          image: AssetImage((widget.alarm.snoozeOn == 1)
                                              ? 'assets/images/snooze_on.png'
                                              : 'assets/images/snooze_off.png'))),
                                  Text(
                                    widget.alarm.snoozeOn == 1 ? 'on' : 'off',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  //***** Action Buttons
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        actionButton(context, "edit", () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditAlarmScreen(
                                      day: widget.day,
                                      alarm: widget.alarm,
                                      prevAlarm: AlarmObject(
                                          alarmTime: widget.alarm.alarmTime,
                                          alarmActive: widget.alarm.alarmActive,
                                          alarmRepeat: widget.alarm.alarmRepeat,
                                          vibrationPattern: widget.alarm.vibrationPattern,
                                          vibrationStrength: widget.alarm.vibrationStrength,
                                          snoozeOn: widget.alarm.snoozeOn,
                                          snoozeMin: widget.alarm.snoozeMin,
                                          alarmName: widget.alarm.alarmName),
                                    )),
                          );
                        }),
                        SizedBox(
                          width: w * 0.1,
                        ),
                        actionButton(context, "delete", () async {
                          await deleteAlarm(
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
                                alarmName: widget.alarm.alarmName),
                          );
                          Navigator.pop(context);
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: h * 0.01,
            ),
          ],
        ),
      ),
    );
  }
}
