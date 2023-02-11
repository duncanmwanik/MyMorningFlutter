// --------------------------------- GLOBALS ---------------------------------
// all other variables, methods and providers

import 'dart:convert';
import 'package:flutter/material.dart';
import '../data/preferences.dart';
import '../methods/datetime.dart';

class GlobalModel with ChangeNotifier {
  // ---------- bottom nav bar
  int selectedTab = 0;

  void selectNewTab(int index) {
    selectedTab = index;
    notifyListeners();
  }

  // ---------- dates

  int selectedDate = DateTime.now().weekday == 7 ? 0 : DateTime.now().weekday;

  void selectNewDate(int index) {
    selectedDate = index;
    notifyListeners();
  }

  final List<DateTime> _currentWeekDates = getCurrentWeekDates();

  List<DateTime> get currentWeekDates {
    return _currentWeekDates;
  }

  // ---------- alarms
  Map<int, List<String>> alarmMap = {0: [], 1: [], 2: [], 3: [], 4: [], 5: [], 6: []};

  // Map<int, List<String>> alarmMap = {
  //   0: [],
  //   1: ["1109045:0", "11090523:30"],
  //   2: [],
  //   3: ["1109045:0", "11090523:30"],
  //   4: [],
  //   5: ["1109045:0", "11090523:30"],
  //   6: ["11090412:55", "1109040:56", "1109049:56", "11090516:58"]
  // };

  void updateAlarmMap(Map<int, List<String>> val) {
    alarmMap = val;
    notifyListeners();
  }

  void resetAlarmMap() {
    alarmMap = {0: [], 1: [], 2: [], 3: [], 4: [], 5: [], 6: []};
    notifyListeners();
  }

  // ---------- alarm names

  Map<String, String> alarmNamesMap = {};

  void getAlarmNames() {
    alarmNamesMap = jsonDecode(prefs.getString("alarmNames") ?? "{}");
    notifyListeners();
  }

  void updateAlarmName({required String alarm, required String name}) {
    alarmNamesMap[alarm] = name;
    notifyListeners();
    saveAlarmNames();
  }

  void deleteAlarmName({required String alarm}) {
    alarmNamesMap.remove(alarm);
    notifyListeners();
    saveAlarmNames();
  }

  // ---------- loading screen
  bool showLoading = false;

  void showLoadingScreen(bool show) {
    showLoading = show;
    notifyListeners();
  }

  // ---------- while pairing screen
  bool onPairing = false;

  void showOnPairing(bool show) {
    onPairing = show;
    notifyListeners();
  }
}
