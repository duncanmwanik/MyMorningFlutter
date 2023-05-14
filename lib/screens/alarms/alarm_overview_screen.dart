import 'package:flutter/material.dart';
import '../../helpers/alarms_helper.dart';
import '../../helpers/datetime_helper.dart';
import '../../variables/constant_variables.dart';
import '../../variables/global_variables.dart';
import '../../models/alarm_model.dart';
import '../../config/theme/theme.dart';
import '../../../widgets/back_button.dart';
import '../../../widgets/change_name_dialog.dart';
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
  late AlarmObject currentAlarm;

  @override
  void initState() {
    setState(() {
      currentAlarm = widget.alarm;
    });
    super.initState();
  }

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
                TextEditingController? textController = TextEditingController(text: currentAlarm.alarmName);

                await changeNameDialog(
                    context: context,
                    description: "Edit alarm name",
                    textController: textController,
                    maxLength: 50,
                    onTap: () async {
                      await globalWatch.deleteAlarmName(alarm: currentAlarm);
                      setState(() {
                        currentAlarm.alarmName = textController.text;
                      });
                      await globalWatch.addAlarmName(alarm: currentAlarm);
                      print(":::::::::::NamesMap>> ${globalWatch.alarmNamesMap.toString()}");
                      Navigator.pop(context, true);
                    });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      currentAlarm.alarmName.isEmpty ? "No alarm Name" : currentAlarm.alarmName,
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
                    image: AssetImage((currentAlarm.alarmTime.hour) >= 12 ? "assets/images/night2.png" : "assets/images/day2.png"),
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
                                get24to12(currentAlarm.alarmTime),
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
                              _vibrationPatternChoice(currentAlarm.vibrationPattern),
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
                                decoration: BoxDecoration(color: Colors.white54, borderRadius: BorderRadius.all(Radius.circular(40))),
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
                                          value: currentAlarm.vibrationStrength.toDouble(),
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
                                          image: AssetImage(
                                              (currentAlarm.snoozeOn == 1) ? 'assets/images/snooze_on.png' : 'assets/images/snooze_off.png'))),
                                  Text(
                                    currentAlarm.snoozeOn == 1 ? 'on' : 'off',
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
                        actionButton(context, "edit", () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditAlarmScreen(
                                      day: widget.day,
                                      alarm: currentAlarm,
                                      prevAlarm: AlarmObject(
                                          alarmTime: currentAlarm.alarmTime,
                                          alarmActive: currentAlarm.alarmActive,
                                          alarmRepeat: currentAlarm.alarmRepeat,
                                          vibrationPattern: currentAlarm.vibrationPattern,
                                          vibrationStrength: currentAlarm.vibrationStrength,
                                          snoozeOn: currentAlarm.snoozeOn,
                                          snoozeMin: currentAlarm.snoozeMin,
                                          alarmName: currentAlarm.alarmName),
                                    )),
                          ).then((alarmData) {
                            print("New data: $alarmData");
                            setState(() {
                              currentAlarm.alarmActive = int.parse(alarmData[0]);
                              currentAlarm.alarmRepeat = int.parse(alarmData[1]);
                              currentAlarm.vibrationPattern = int.parse(alarmData[2]);
                              currentAlarm.vibrationStrength = int.parse(alarmData[3]);
                              currentAlarm.snoozeOn = int.parse(alarmData[4]);
                              currentAlarm.snoozeMin = int.parse(alarmData[5]);
                              currentAlarm.alarmTime = TimeOfDay(
                                  hour: int.parse(alarmData.substring(6).split(":")[0]), minute: int.parse(alarmData.substring(6).split(":")[1]));
                            });
                          });
                        }),
                        SizedBox(
                          width: w * 0.1,
                        ),
                        actionButton(context, "delete", () async {
                          bool isDeleted = await deleteAlarm(
                            context: context,
                            day: globalWatch.selectedDate,
                            alarm: AlarmObject(
                                alarmTime: currentAlarm.alarmTime,
                                alarmActive: currentAlarm.alarmActive,
                                alarmRepeat: currentAlarm.alarmRepeat,
                                vibrationPattern: currentAlarm.vibrationPattern,
                                vibrationStrength: currentAlarm.vibrationStrength,
                                snoozeOn: currentAlarm.snoozeOn,
                                snoozeMin: currentAlarm.snoozeMin,
                                alarmName: currentAlarm.alarmName),
                          );
                          if (isDeleted) {
                            Navigator.pop(context);
                          }
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
