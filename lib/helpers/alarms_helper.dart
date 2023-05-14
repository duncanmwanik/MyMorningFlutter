// --------------------------------- Alarm Methods ---------------------------------
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';

import '../variables/ble_variables.dart';
import '../services/local_storage_service.dart';
import '../models/alarm_model.dart';
import '../variables/global_variables.dart';
import '../screens/home/home_screen.dart';
import '../widgets/confirm_delete_dialog.dart';
import '../widgets/loading_circle.dart';
import '../widgets/toast.dart';
import 'ble_helper.dart';
import 'global_helper.dart';

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
      // await sendDataToDevice("g");

      await Future.delayed(Duration(milliseconds: 500));

      // read the alarm list data
      List<int>? value = await rble.readCharacteristic(alarmCharacteristic);

      List<String> days = parseReceivedBLEDataToString(value).split("#");
      Map<int, List<String>> allAlarms = {};

      if (days.length < 7) {
        for (int day = 0; day < 7; day++) {
          allAlarms[day] = [];
        }
      } else {
        for (int day = 0; day < days.length; day++) {
          // if the alarm list is invalid
          if (days[day].length < 8) {
            allAlarms[day] = [];
          } else {
            // removes the extra "|" at the end of each day's alarm list
            String dayList = days[day].substring(0, days[day].length - 1);
            allAlarms[day] = dayList.split("|");
          }
        }
      }

      globalWatch.updateAlarmMap(allAlarms);

      // print("Alarms: $allAlarms");
    } else {
      toast(0, "No device connected!");
    }
  } catch (e) {
    toast(0, "Failed to sync alarms!");
    errorPrint("get-alarms", e);
  }
}

Future<void> addAlarm(BuildContext context, {required List selectedDays, required AlarmObject alarm}) async {
  if (bleWatch.btState) {
    if (bleWatch.connected) {
      if (parseReceivedBLEDataToString(await rble.readCharacteristic(alarmCharacteristic)) != "1") {
        try {
          showLoadingCircle(context);

          String days = selectedDays.join('');
          String data = "a${getAlarmData(alarm)}/$days";
          print(">>>>DATA: $data");
          await sendDataToDevice(data);
          await globalWatch.addAlarmName(alarm: alarm);

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
        toast(2, "Can't set alarm when alarm is ringing!");
      }
    } else {
      toast(0, "No device connected!");
    }
  } else {
    toast(0, "Bluetooth is off");
  }
}

Future<void> editAlarm(BuildContext context,
    {required int day, required AlarmObject prevAlarm, required AlarmObject alarm, required popScreen}) async {
  if (bleWatch.btState) {
    if (bleWatch.connected) {
      try {
        showLoadingCircle(context);
        String prevTime = '${prevAlarm.alarmTime.hour}:${prevAlarm.alarmTime.minute}';
        String alarmData = getAlarmData(alarm);
        String data = "e$day/$prevTime/$alarmData";
        await sendDataToDevice(data);
        await globalWatch.deleteAlarmName(alarm: prevAlarm);
        await globalWatch.addAlarmName(alarm: alarm);
        await getAlarmListFromDevice();

        print(":::::::::::NamesMap>> ${globalWatch.alarmNamesMap.toString()}");

        removeLoadingCircle(context);
        await globalWatch.updateSelectedTab(0);

        if (popScreen) {
          Navigator.pop(context, alarmData);
        }
      } catch (e) {
        removeLoadingCircle(
          context,
        );
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

Future<bool> deleteAlarm({required BuildContext context, required int day, required AlarmObject alarm}) async {
  bool? delete = await showConfirmDeletionDialog(context);
  if (delete != null && delete == true) {
    try {
      String time = '${alarm.alarmTime.hour}:${alarm.alarmTime.minute}';
      await sendDataToDevice('d$day/$time');
      await globalWatch.deleteAlarmName(alarm: alarm);
      await getAlarmListFromDevice();

      print(":::::::::::NamesMap>> ${globalWatch.alarmNamesMap.toString()}");

      return delete;
    } catch (e) {
      errorPrint("delete-alarm", e);
      return false;
    }
  } else {
    return false;
  }
}
