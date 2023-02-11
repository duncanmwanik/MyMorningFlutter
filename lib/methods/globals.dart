// --------------------------------- GLOBALS ---------------------------------
// all other variables, methods and providers

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/ble.dart';
import '../state/globals.dart';

// --------------------------------- Provider refs ---------------------------------
var globalWatch;
var bleWatch;
var dateTimeWatch;

void createProviderReferences({BuildContext? context}) {
  globalWatch = context?.watch<GlobalModel>();
  bleWatch = context?.watch<BleModel>();
}

// --------------------------------- Screen Size ---------------------------------

// screen sizes
double h = 0;
double w = 0;

void getDeviceSize(BuildContext context) {
  // get device screen size and save them globally
  h = MediaQuery.of(context).size.height;
  w = MediaQuery.of(context).size.width;
}

// --------------------------------- Debug ---------------------------------
void errorPrint(String where, var e) {
  print("!!! ERROR :: $where >> [[  $e  ]]");
}

// --------------------------------- Gestures ---------------------------------

void swipeToNextDay() async {
  int day = globalWatch.selectedDate;
  if (day == 6) {
    day = 0;
  } else {
    day++;
  }
  await globalWatch.selectNewDate(day);
  // print(day);
}

void swipeToPreviousDay() async {
  int day = globalWatch.selectedDate;
  if (day == 0) {
    day = 6;
  } else {
    day--;
  }
  await globalWatch.selectNewDate(day);

  // print(day);
}

void swipe(DragEndDetails details) {
  if (details.primaryVelocity == null) {
    return;
  }
  if (details.primaryVelocity! < 0) {
    swipeToNextDay();
  }
  if (details.primaryVelocity! > 0) {
    swipeToPreviousDay();
  }
}

// --------------------------------- Navigation ---------------------------------

popScreen(BuildContext context) {
  Navigator.pop(context);
}

popScreenValue(BuildContext context, dynamic value) {
  Navigator.pop(context, value);
}

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// class MyNavigator {
//   push(dynamic to) {
//     navigatorKey.currentState?.push(to);
//   }

//   pushAndRemoveUntil(dynamic to) {
//     navigatorKey.currentState?.pushAndRemoveUntil(
//       to,
//       (route) => false,
//     );
//   }

//   pop() {
//     navigatorKey.currentState?.pop();
//   }
// }

// ---------------------------------  ---------------------------------
