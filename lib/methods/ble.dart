// --------------------------------- BLE ---------------------------------
// all ble variables, methods and providers

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../data/preferences.dart';
import '../ui/widgets/toast.dart';
import 'globals.dart';

String serviceUuid = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
String charaCteristicUuidBattery = "beb54800-36e1-4688-b7f5-ea07361b26a8";
String charaCteristicUuidAlarm = "beb54811-36e1-4688-b7f5-ea07361b26a8";
String charaCteristicUuidCommand = "beb54822-36e1-4688-b7f5-ea07361b26a8";
BluetoothCharacteristic? cBattery;
BluetoothCharacteristic? cAlarm;
BluetoothCharacteristic? cCommand;
Stream<List<int>>? streamBattery;
Stream<List<int>>? streamAlarm;
Stream<List<int>>? streamCommand;

sendDataToDevice(String dataString) async {
  //Encoding the string
  List<int> data = utf8.encode(dataString);
  print(data);
  try {
    await cCommand!.write(data);
    print("!!Success >> sent data : $dataString");
  } catch (e) {
    print("!! Failed  to send data : $dataString");
    print(e);
  }
}

disconnectFromDevice(BluetoothDevice? d) async {
  try {
    await d!.disconnect();
    await bleWatch.setDevice(null);
    await bleWatch.setConnectionState(false);
    print("..... disconnected device!");
  } catch (e) {
    errorPrint("disconnecting", e);
  }
}

discoverServices(BluetoothDevice d) async {
  List<BluetoothService> services = await d.discoverServices();
  for (var service in services) {
    if (service.uuid.toString() == serviceUuid) {
      for (var characteristic in service.characteristics) {
        if (characteristic.uuid.toString() == charaCteristicUuidBattery) {
          await characteristic.setNotifyValue(!characteristic.isNotifying);
          streamBattery = characteristic.value;
          cBattery = characteristic;
        }
        if (characteristic.uuid.toString() == charaCteristicUuidAlarm) {
          await characteristic.setNotifyValue(!characteristic.isNotifying);
          streamAlarm = characteristic.value;
          cAlarm = characteristic;
        }
        if (characteristic.uuid.toString() == charaCteristicUuidCommand) {
          await characteristic.setNotifyValue(!characteristic.isNotifying);
          streamCommand = characteristic.value;
          cCommand = characteristic;
        }
      }
    }
  }
}

Future<bool> connectDevice(BluetoothDevice device) async {
  try {
    await globalWatch.showOnPairing(true);

    await disconnectFromDevice(device);
    await device.connect();
    await discoverServices(device);
    print("..... connected device!");
    await bleWatch.setDevice(device);
    await bleWatch.setConnectionState(true);
    await prefs.setString("lastDeviceId", device.id.toString());
    await getAlarmList();
    await syncTime();

    device.state.listen((event) async {
      if (event != BluetoothDeviceState.connected) {
        toast(0, "Lost connection to device!");
        await bleWatch.setDevice(null);
        await bleWatch.setConnectionState(false);
        await globalWatch.resetAlarmMap();
      }
    });
    return true;
  } catch (e) {
    errorPrint("connect-device", e);
    // toast(0, "Failed to connect device!");
    return false;
  }
}

// the app will try to connect to the last connected device
Future<void> checkAlreadyConnectedDevices() async {
  print("....... trying to auto-connect");

  String? id = prefs.getString("lastDeviceId");
  FlutterBlue.instance.connectedDevices.then((devices) async {
    for (var device in devices) {
      try {
        if (device.id.toString() == id) {
          await discoverServices(device);
          await bleWatch.setDevice(device);
          await bleWatch.setConnectionState(true);
        }
      } catch (e) {
        errorPrint("autoconnect", e);
      } finally {
        await getAlarmList();
        await syncTime();
      }
    }
  });
}

Future<void> syncTime() async {
  final now = DateTime.now();
  await sendDataToDevice("t${now.second}-${now.minute}-${now.hour}-${now.day}-${now.month}-${now.year}-");
}

// getting all alarms from the device
Future<void> getAlarmList() async {
  try {
    if (bleWatch.connected) {
      // tell the device to prepare the alarm list
      await sendDataToDevice("g");
      // read the alarm list data
      List<int>? value = await cAlarm?.read();

      List<String> days = parseBLEData(value).split("#");
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
    toast(0, "Failed to get your alarms! Try to reconnect the device.");
    errorPrint("get-alarms", e);
  }
}

Future<bool> addAlarm(
    {required String alarmName,
    required List selectedDays,
    required TimeOfDay alarmTime,
    required int alarmActive,
    required int alarmRepeat,
    required int vibrationPattern,
    required int vibrationStrength,
    required int snoozeOn,
    required int snoozeMin}) async {
  try {
    String days = selectedDays.join('');
    String time = '${alarmTime.hour}:${alarmTime.minute}';
    String data = "a$alarmActive$alarmRepeat$vibrationPattern$vibrationStrength$snoozeOn$snoozeMin$time/$days";
    print(data);
    await sendDataToDevice(data);
    // await globalWatch.updateAlarmName(alarm: time, name: alarmName);
    return true;
  } catch (e) {
    errorPrint("add-alarm", e);
    return false;
  }
}

Future<bool> editAlarm(
    {required int day,
    required TimeOfDay prevTime,
    required String alarmName,
    required TimeOfDay alarmTime,
    required int alarmActive,
    required int alarmRepeat,
    required int vibrationPattern,
    required int vibrationStrength,
    required int snoozeOn,
    required int snoozeMin}) async {
  try {
    String time = '${alarmTime.hour}:${alarmTime.minute}';
    String prev = '${prevTime.hour}:${prevTime.minute}';
    String data = "e$day/$prev/$alarmActive$alarmRepeat$vibrationPattern$vibrationStrength$snoozeOn$snoozeMin$time";
    await sendDataToDevice(data);
    return true;
    // await globalWatch.deleteAlarm(alarm: prevTime);
    // await globalWatch.updateAlarmName(alarm: time, name: alarmName);
  } catch (e) {
    errorPrint("edit-alarm", e);
    return false;
  }
}

Future<void> deleteAlarm({required int day, required TimeOfDay alarmTime}) async {
  try {
    String time = '${alarmTime.hour}:${alarmTime.minute}';
    await sendDataToDevice('d$day/$time');
    // await globalWatch.deleteAlarm(alarm: time);
  } catch (e) {
    errorPrint("delete-alarm", e);
  }
}

Future<void> turnOffDevice() async {
  try {
    await sendDataToDevice('o');
    disconnectFromDevice(bleWatch.device);
  } catch (e) {
    errorPrint("turn-off-device", e);
  }
}

String parseBLEData(List<int>? dataFromDevice) {
  if (dataFromDevice == [] && dataFromDevice == null) {
    return "404";
  } else {
    return utf8.decode(dataFromDevice!);
  }
}

Future<void> getBatteryPercentage() async {
  try {
    if (bleWatch.connected) {
      List<int>? value = await cBattery?.read();
      int percentage = int.parse(parseBLEData(value));
      if (percentage == 404) {
      } else if (percentage > 100) {
        percentage = 100;
      } else if (percentage < 0) {
        percentage = 0;
      } else {}

      bleWatch.updateBatteryPercentage(percentage);
    } else {
      // print("------ not connected!");
    }
  } catch (e) {
    errorPrint("get-battery-percentage", e);
  }
}
