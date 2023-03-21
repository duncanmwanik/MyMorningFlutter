import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleModel with ChangeNotifier {
  // ********** ble **********
  BluetoothDevice? device;
  bool connected = false;
  bool btState = false;

  void setDevice(BluetoothDevice? dev) {
    device = dev;
    notifyListeners();
  }

  void setConnectionState(bool state) {
    connected = state;
    notifyListeners();
  }

  void updateBtState(bool state) {
    btState = state;
    notifyListeners();
  }

  // ********** batter percentage **********
  int batteryPercentage = 70;

  void updateBatteryPercentage(int percentage) {
    batteryPercentage = percentage;
    notifyListeners();
  }
}