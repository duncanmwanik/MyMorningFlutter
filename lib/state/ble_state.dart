import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BleModel with ChangeNotifier {
  // ********** ble **********
  DiscoveredDevice? device;
  bool connected = false;
  bool btState = false;

  void setDevice(DiscoveredDevice? dev) {
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
