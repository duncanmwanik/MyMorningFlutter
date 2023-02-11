import 'package:flutter/material.dart';

class ThemeModel with ChangeNotifier {
  // ********** ble **********
  bool enableDarkTheme = false;

  void setDarkTheme(bool enable) {
    enableDarkTheme = enable;
    notifyListeners();
  }
}
