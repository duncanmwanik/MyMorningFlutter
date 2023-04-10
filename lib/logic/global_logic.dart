// --------------------------------- GLOBALS ---------------------------------
// all other variables, methods and providers

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../state/ble_state.dart';
import '../state/global_state.dart';
import '../_variables/global_variables.dart';

void createGlobalProviderReferences({BuildContext? context}) {
  globalWatch = context?.watch<GlobalModel>();
  bleWatch = context?.watch<BleModel>();
}

// --------------------------------- Screen Size ---------------------------------
void getDeviceScreenDimensions(BuildContext context) {
  // get device screen size and save them globally
  h = MediaQuery.of(context).size.height;
  w = MediaQuery.of(context).size.width;
}

// --------------------------------- Gestures ---------------------------------

void selectNewDay(String newDay) async {
  int day = globalWatch.selectedDate;
  if (newDay == "NextDay") {
    day = day >= 6 ? 0 : day + 1;
  }
  if (newDay == "PreviousDay") {
    day = day <= 0 ? 6 : day - 1;
  }
  print(day);
  await globalWatch.selectNewDate(day);
}

void swipeToAnotherDay(DragEndDetails details) {
  if (details.primaryVelocity == null) {
    return;
  }
  if (details.primaryVelocity! < 0) {
    selectNewDay("NextDay");
  }
  if (details.primaryVelocity! > 0) {
    selectNewDay("PreviousDay");
  }
}

// --------------------------------- Navigation ---------------------------------

// --------------------------------- Debugging Helpers ---------------------------------
void errorPrint(String where, var e) {
  print("!!! ERROR :: $where >> [  $e  ]");
}

// --------------------------------- Navigation ---------------------------------
void setFirstTimeStateToFalse() async {
  // set first time running the app to false
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("firstTime", false);
}

void removeLoadingCircle(BuildContext context) {
  Navigator.pop(context);
}
