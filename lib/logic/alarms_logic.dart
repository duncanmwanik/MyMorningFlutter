// --------------------------------- Alarm Methods ---------------------------------
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';

import '../data/preferences.dart';
import '../models/alarm_model.dart';
import '../_variables/global_variables.dart';
import '../ui/screens/home/home_screen.dart';
import '../ui/widgets/confirm_delete_dialog.dart';
import '../ui/widgets/loading_circle.dart';
import '../ui/widgets/toast.dart';
import 'ble_logic.dart';
import 'global_logic.dart';

List<String> sortAlarmsByTime(List<String> ls) {
  Map<int, String> mp = {};
  for (String e in ls) {
    mp[int.parse(e.substring(6).split(":").join(""))] = e;
  }
  mp = SplayTreeMap<int, String>.from(mp, (k1, k2) => k1.compareTo(k2));

  return mp.values.toList();
}

String getAlarmData(AlarmObject alarm) {
  String alarmData =
      "${alarm.alarmActive}${alarm.alarmRepeat}${alarm.vibrationPattern}${alarm.vibrationStrength}${alarm.snoozeOn}${alarm.snoozeMin}${alarm.alarmTime.hour}:${alarm.alarmTime.minute}";
  return alarmData;
}

// update alarmNames in storage
void saveAlarmNames() {
  prefs.setString("alarmNames", jsonEncode(globalWatch.alarmNamesMap));
}

void loadAlarmNamesFromPhoneStorage() {
  globalWatch.getAlarmNamesMap();
}

String getAlarmNameFromMap(AlarmObject alarm) {
  String key = getAlarmData(
    alarm,
  ).replaceAll(RegExp(r':'), '-');

  String name = "";
  if (globalWatch.alarmNamesMap.containsKey(key)) {
    name = globalWatch.alarmNamesMap[key];
  } else {
    name = "My Alarm";
  }

  return name;
}

// getting all alarms from the device
Future<void> getAlarmListFromDevice() async {
  try {
    if (bleWatch.connected) {
      // tell the device to prepare the alarm list
      await sendDataToDevice("g");

      await Future.delayed(Duration(milliseconds: 200), () {});

      // read the alarm list data
      List<int>? value = await alarmCharacteristic?.read();

      List<String> days = parseReceivedBLEDataToString(value).split("#");
      Map<int, List<String>> all = {};

      if (days.length < 7) {
        for (int day = 0; day < 7; day++) {
          all[day] = [];
        }
      } else {
        for (int day = 0; day < days.length; day++) {
          // if the alarm list is invalid
          if (days[day].length < 8) {
            all[day] = [];
          } else {
            // removes the extra "|" at the end of each day's alarm list
            String dayList = days[day].substring(0, days[day].length - 1);
            all[day] = dayList.split("|");
          }
        }
      }

      globalWatch.updateAlarmMap(all);
      // print("_____________________________");
      // print("::::: ALARM-MAP : $all");
      // print("_____________________________");
    } else {
      toast(0, "No device connected!");
    }
  } catch (e) {
    // toast(0, "Failed to get your alarms! Try to reconnect the device.");
    errorPrint("get-alarms", e);
  }
}

Future<void> addAlarm(BuildContext context, {required List selectedDays, required AlarmObject alarm}) async {
  if (bleWatch.btState) {
    if (bleWatch.connected) {
      if (parseReceivedBLEDataToString(await alarmCharacteristic?.read()) != "1") {
        try {
          showLoadingCircle(context);

          String days = selectedDays.join('');
          String data = "a${getAlarmData(alarm)}/$days";
          await sendDataToDevice(data);
          await globalWatch.addAlarmName(alarm: alarm);

          await Future.delayed(Duration(milliseconds: 500), () {});
          await getAlarmListFromDevice();

          print(":::::::::::NamesMap>> ${globalWatch.alarmNamesMap.toString()}");

          removeLoadingCircle(context);
          await globalWatch.updateSelectedTab(0);
          Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => HomeScreen(),
            ),
            (route) => false,
          );
        } catch (e) {
          removeLoadingCircle(context);
          toast(0, "Failed to add alarm!!");
          errorPrint("add-alarm", e);
        }
      } else {
        toast(0, "Can't set alarm when alarm is ringing!");
      }
    } else {
      toast(0, "No device connected!");
    }
  } else {
    toast(0, "Bluetooth is off");
  }
}

Future<void> editAlarm(BuildContext context,
    {required int day, required AlarmObject prevAlarm, required AlarmObject alarm}) async {
  if (bleWatch.btState) {
    if (bleWatch.connected) {
      try {
        showLoadingCircle(context);
        String prevTime = '${prevAlarm.alarmTime.hour}:${prevAlarm.alarmTime.minute}';
        String data = "e$day/$prevTime/${getAlarmData(alarm)}";
        await sendDataToDevice(data);
        await globalWatch.deleteAlarmName(alarm: prevAlarm);
        await globalWatch.addAlarmName(alarm: alarm);
        await Future.delayed(Duration(milliseconds: 500), () {});
        await getAlarmListFromDevice();

        print(":::::::::::NamesMap>> ${globalWatch.alarmNamesMap.toString()}");

        removeLoadingCircle(context);
        await globalWatch.updateSelectedTab(0);
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => HomeScreen(),
          ),
          (route) => false,
        );
      } catch (e) {
        removeLoadingCircle(context);
        toast(0, "Failed to edit alarm!");
        errorPrint("edit-alarm", e);
      }
    } else {
      toast(0, "No device connected!");
    }
  } else {
    toast(0, "Bluetooth is off");
  }
}

Future<void> deleteAlarm({required BuildContext context, required int day, required AlarmObject alarm}) async {
  bool? delete = await showConfirmDeletionDialog(context);
  if (delete != null && delete == true) {
    try {
      String time = '${alarm.alarmTime.hour}:${alarm.alarmTime.minute}';
      await sendDataToDevice('d$day/$time');
      await globalWatch.deleteAlarmName(alarm: alarm);
      await getAlarmListFromDevice();

      print(":::::::::::NamesMap>> ${globalWatch.alarmNamesMap.toString()}");
    } catch (e) {
      errorPrint("delete-alarm", e);
    }
  }
}
