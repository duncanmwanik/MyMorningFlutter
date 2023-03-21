// --------------------------------- GLOBALS ---------------------------------
// all other variables, methods and providers

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mymorning/logic/alarms_logic.dart';
import '../data/preferences.dart';
import '../logic/datetime_logic.dart';
import '../logic/global_logic.dart';
import '../models/alarm_model.dart';

class GlobalModel with ChangeNotifier {
  // ---------- bottom nav bar
  int selectedTab = 0;

  void updateSelectedTab(int index) {
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

  void updateAlarmMap(Map<int, List<String>> val) {
    alarmMap = val;
    notifyListeners();
  }

  void resetAlarmMap() {
    alarmMap = {0: [], 1: [], 2: [], 3: [], 4: [], 5: [], 6: []};
    notifyListeners();
  }

  // ---------- alarm names
  Map<dynamic, dynamic> alarmNamesMap = {};

  void getAlarmNamesMap() {
    // prefs.remove("alarmNames");
    alarmNamesMap = jsonDecode(prefs.getString("alarmNames") ?? "{}");
    notifyListeners();
  }

  void addAlarmName({required AlarmObject alarm}) {
    try {
      // print(":::::::::::adding>> ${getAlarmData(alarm).replaceAll(RegExp(r':'), '-')}");
      alarmNamesMap[getAlarmData(alarm).replaceAll(RegExp(r':'), '-')] = alarm.alarmName;
      saveAlarmNames();
      notifyListeners();
    } catch (e) {
      errorPrint("add-alarm-name", e);
    }
  }

  void deleteAlarmName({required AlarmObject alarm}) {
    try {
      // print(":::::::::::deleting>> ${getAlarmData(alarm).replaceAll(RegExp(r':'), '-')}");
      if (alarmNamesMap.containsKey(getAlarmData(alarm).replaceAll(RegExp(r':'), '-'))) {
        alarmNamesMap.remove(getAlarmData(alarm).replaceAll(RegExp(r':'), '-'));
        saveAlarmNames();
        notifyListeners();
      }
    } catch (e) {
      errorPrint("delete-alarm-name", e);
    }
  }

  // ---------- while pairing screen
  bool onPairing = false;

  void showOnPairing(bool show) {
    onPairing = show;
    notifyListeners();
  }
}