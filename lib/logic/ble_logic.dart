import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:mymorning/ui/widgets/loading_circle.dart';

import '../data/preferences.dart';
import '../ui/widgets/toast.dart';
import '../_variables/global_variables.dart';
import '../_variables/constant_variables.dart';
import 'alarms_logic.dart';
import 'global_logic.dart';

BluetoothCharacteristic? batteryCharacteristic;
BluetoothCharacteristic? alarmCharacteristic;
BluetoothCharacteristic? commandCharacteristic;
Stream<List<int>>? streamBattery;
Stream<List<int>>? streamAlarm;
Stream<List<int>>? streamCommand;

sendDataToDevice(String dataString) async {
  //Encoding the string inti utf8 type data
  List<int> data = utf8.encode(dataString);
  try {
    await commandCharacteristic!.write(data);
    print(":::::::::: Success >> sent command: $dataString");
  } catch (e) {
    print(":::::::::: Failed  >> to send command : $dataString");
    print(e);
  }
}

disconnectFromDevice(BluetoothDevice? d) async {
  try {
    await d!.disconnect();
    await bleWatch.setDevice(null);
    await bleWatch.setConnectionState(false);
    print(":::::::::: disconnected device!");
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
          batteryCharacteristic = characteristic;
        }
        if (characteristic.uuid.toString() == charaCteristicUuidAlarm) {
          await characteristic.setNotifyValue(!characteristic.isNotifying);
          streamAlarm = characteristic.value;
          alarmCharacteristic = characteristic;
        }
        if (characteristic.uuid.toString() == charaCteristicUuidCommand) {
          await characteristic.setNotifyValue(!characteristic.isNotifying);
          streamCommand = characteristic.value;
          commandCharacteristic = characteristic;
        }
      }
    }
  }
}

void selectDevice(BuildContext context, BluetoothDevice device) async {
  print(":::::::: SELECTING");
  try {
    globalWatch.showOnPairing(true);
    await discoverServices(device);
    await bleWatch.setDevice(device);
    await bleWatch.setConnectionState(true);
    await prefs.setString("lastDeviceId", device.id.toString());
    await syncTime();
    await getAlarmListFromDevice();

    device.state.listen((event) async {
      if (event != BluetoothDeviceState.connected) {
        // toast(0, "Lost connection to device!");
        await bleWatch.setDevice(null);
        await bleWatch.setConnectionState(false);
        await globalWatch.resetAlarmMap();
      }
    });

    await globalWatch.showOnPairing(false);
    Navigator.pop(context);
  } catch (e) {
    await globalWatch.showOnPairing(false);
    errorPrint("select-device", e);
    toast(0, "Failed to connect device!");
  }
}

Future<void> connectDevice(BuildContext context, bool firstTime, BluetoothDevice device) async {
  print(":::::::: CONNECTING");
  try {
    globalWatch.showOnPairing(true);
    await device.connect();
    await discoverServices(device);
    await bleWatch.setDevice(device);
    await bleWatch.setConnectionState(true);
    await prefs.setString("lastDeviceId", device.id.toString());
    await syncTime();
    await getAlarmListFromDevice();

    device.state.listen((event) async {
      if (event != BluetoothDeviceState.connected) {
        // toast(0, "Lost connection to device!");
        await bleWatch.setDevice(null);
        await bleWatch.setConnectionState(false);
        await globalWatch.resetAlarmMap();
      }
    });

    await globalWatch.showOnPairing(false);
    Navigator.pop(context);

    // if (firstTime) {
    //   Navigator.pushAndRemoveUntil<dynamic>(
    //     context,
    //     MaterialPageRoute<dynamic>(
    //       builder: (BuildContext context) => PairingStatusScreen(success: success),
    //     ),
    //     (route) => false,
    //   );
    // } else {
    //   Navigator.pop(context);
    // }
  } catch (e) {
    await globalWatch.showOnPairing(false);
    toast(0, "Failed to connect device!");
    errorPrint("connect-device", e);
  }
}

// the app will try to connect to the last connected device
Future<void> checkAlreadyConnectedDevices() async {
  print("....... trying to auto-connect");

  String? id = prefs.getString("lastDeviceId");
  FlutterBluePlus.instance.connectedDevices.then((devices) async {
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
        await getAlarmListFromDevice();
        // await syncTime();
      }
    }
  });
}

Future<void> syncTime() async {
  try {
    final now = DateTime.now();
    await sendDataToDevice("t${now.second}-${now.minute}-${now.hour}-${now.day}-${now.month}-${now.year}-");
  } catch (e) {
    errorPrint("sync-time-device", e);
  }
}

Future<void> turnOffDevice() async {
  try {
    await sendDataToDevice('off');
    disconnectFromDevice(bleWatch.device);
  } catch (e) {
    errorPrint("turn-off-device", e);
  }
}

String parseReceivedBLEDataToString(List<int>? dataFromDevice) {
  if (dataFromDevice == null || dataFromDevice == []) {
    return "404";
  } else {
    return utf8.decode(dataFromDevice);
  }
}

Future<void> getBatteryPercentage() async {
  try {
    if (bleWatch.connected) {
      List<int>? value = await batteryCharacteristic?.read();
      int percentage = int.parse(parseReceivedBLEDataToString(value));
      if (percentage == 404) {
      } else if (percentage > 100) {
        percentage = 100;
      } else if (percentage < 0) {
        percentage = 0;
      } else {}

      bleWatch.updateBatteryPercentage(percentage);
      print(percentage);
    }
  } catch (e) {
    errorPrint("get-battery-percentage", e);
  }
}
