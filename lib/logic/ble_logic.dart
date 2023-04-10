import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:location_permissions/location_permissions.dart';

import '../_variables/ble_variables.dart';
import '../data/preferences.dart';
import '../ui/widgets/toast.dart';
import '../_variables/global_variables.dart';
import '../_variables/constant_variables.dart';
import 'alarms_logic.dart';
import 'global_logic.dart';

late StreamSubscription<ConnectionStateUpdate> deviceConnection;
late QualifiedCharacteristic batteryCharacteristic;
late QualifiedCharacteristic alarmCharacteristic;
late QualifiedCharacteristic commandCharacteristic;
late StreamSubscription<DiscoveredDevice> streamBattery;
late StreamSubscription<DiscoveredDevice> streamAlarm;
late StreamSubscription<DiscoveredDevice> streamCommand;

sendDataToDevice(String dataString) async {
  //Encoding the string inti utf8 type data
  List<int> data = utf8.encode(dataString);
  try {
    rble.writeCharacteristicWithoutResponse(commandCharacteristic, value: data);
    print(":::::::::: Success >> sent command: $dataString");
  } catch (e) {
    print(":::::::::: Failed  >> to send command : $dataString");
    print(e);
  }
}

disconnectFromDevice() async {
  try {
    deviceConnection.cancel();
    await bleWatch.setDevice(null);
    await bleWatch.setConnectionState(false);
    globalWatch.resetAlarmMap();
    print(":::::::::: disconnected device!");
  } catch (e) {
    errorPrint("disconnecting", e);
  }
}

Future<void> discoverCharacteristics(DiscoveredDevice device) async {
  alarmCharacteristic =
      QualifiedCharacteristic(serviceId: Uuid.parse(serviceUuid), characteristicId: Uuid.parse(characteristicUuidAlarm), deviceId: device.id);
  commandCharacteristic =
      QualifiedCharacteristic(serviceId: Uuid.parse(serviceUuid), characteristicId: Uuid.parse(characteristicUuidCommand), deviceId: device.id);
  batteryCharacteristic =
      QualifiedCharacteristic(serviceId: Uuid.parse(serviceUuid), characteristicId: Uuid.parse(characteristicUuidBattery), deviceId: device.id);
}

// void selectDevice(dynamic deviceId) async {
//   print(":::::::: SELECTING");
//   try {
//     globalWatch.showOnPairing(true);

//     deviceConnection = rble.connectToDevice(id: deviceId).listen(
//       (update) async {
//         // if (update.connectionState == DeviceConnectionState.disconnected) {
//         //   toast(0, "Lost connection to device");
//         //   await bleWatch.setDevice(null);
//         //   await bleWatch.setConnectionState(false);
//         // }
//       },
//       onError: (Object e) {},
//     );

//     await bleWatch.setDevice(deviceId);
//     await bleWatch.setConnectionState(true);
//     await prefs.setString("lastDeviceId", deviceId.toString());
//     await syncTime();
//     await getAlarmListFromDevice();
//   } catch (e) {
//     errorPrint("select-device", e);
//   }
// }

Future<void> connectDevice(BuildContext context, bool firstTime, DiscoveredDevice device) async {
  print(":::::::: CONNECTING");
  try {
    globalWatch.showOnPairing(true);

    deviceConnection = rble.connectToDevice(id: device.id).listen(
      (update) async {
        if (update.connectionState == DeviceConnectionState.disconnected) {
          // toast(0, "Lost connection to device");
          // await bleWatch.setDevice(null);
          // await bleWatch.setConnectionState(false);
        }
      },
      onError: (Object e) async {
        await globalWatch.showOnPairing(false);
      },
    );

    discoverCharacteristics(device);

    await bleWatch.setDevice(device);
    await bleWatch.setConnectionState(true);
    await prefs.setString("lastDeviceId", device.id.toString());
    await syncTime();
    Future.delayed(Duration(milliseconds: 500));
    await getAlarmListFromDevice();

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
// Future<void> checkAlreadyConnectedDevices() async {
//   print("....... trying to auto-connect");

//   // String? id = prefs.getString("lastDeviceId");
//   rble.connectedDeviceStream.listen((event) {
//     print(event.deviceId.toLowerCase());
//     rble.connectToDevice(id: event.deviceId);
//   });
//   // FlutterBluePlus.instance.connectedDevices.then((devices) async {
//   //   for (var device in devices) {
//   //     try {
//   //       if (device.id.toString() == id) {
//   //         await discoverServices(device);
//   //         await bleWatch.setDevice(device);
//   //         await bleWatch.setConnectionState(true);
//   //       }
//   //     } catch (e) {
//   //       errorPrint("autoconnect", e);
//   //     } finally {
//   //       await getAlarmListFromDevice();
//   //       // await syncTime();
//   //     }
//   //   }
//   // });
// }

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
    disconnectFromDevice();
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
      List<int>? value = await rble.readCharacteristic(batteryCharacteristic);
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

Future<void> getBLEPermissions() async {
  try {
    bool permGranted = false;
    PermissionStatus permission;
    if (Platform.isAndroid) {
      permission = await LocationPermissions().requestPermissions();
      if (permission == PermissionStatus.granted) permGranted = true;
    } else if (Platform.isIOS) {
      permGranted = true;
    }
  } catch (e) {
    errorPrint("get-ble-permissions", e);
  }
}
