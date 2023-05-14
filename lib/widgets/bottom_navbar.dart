import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../variables/global_variables.dart';
import '../models/alarm_model.dart';
import '../screens/home/home_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../config/theme/theme.dart';
import '../screens/alarms/add_alarm_screen.dart';
import '../screens/ble_devices/devices_screen.dart';

Widget bottomNavbar(BuildContext context, bool showCircleIndicators) {
  List<dynamic> tabs = [
    HomeScreen(),
    AddAlarmScreen(
        selectedDays: [globalWatch.selectedDate],
        alarm: AlarmObject(
            alarmTime: TimeOfDay.now(),
            alarmActive: 1,
            alarmRepeat: 1,
            vibrationPattern: 0,
            vibrationStrength: 9,
            snoozeOn: 0,
            snoozeMin: 1,
            alarmName: "My Alarm")),
    DevicesScreen(),
    ProfileScreen()
  ];

  Widget circleIndicator(int day) {
    return Container(
      width: w * 0.02,
      height: w * 0.02,
      decoration: BoxDecoration(
        color: day == globalWatch.selectedDate ? primaryColor : Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }

  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    mainAxisSize: MainAxisSize.min,
    children: [
      showCircleIndicators
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                circleIndicator(0),
                circleIndicator(1),
                circleIndicator(2),
                circleIndicator(3),
                circleIndicator(4),
                circleIndicator(5),
                circleIndicator(6),
              ],
            )
          : Container(),
      FloatingNavbar(
        onTap: (int val) async {
          if (val != globalWatch.selectedTab) {
            globalWatch.updateSelectedTab(val);
            if (val != 1) {
              Navigator.pushAndRemoveUntil<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => tabs[val],
                ),
                (route) => false,
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => tabs[val]),
              );
            }
          }
        },
        elevation: 0,
        backgroundColor: primaryColor,
        selectedBackgroundColor: Colors.white30,
        selectedItemColor: Colors.white,
        borderRadius: 20,
        itemBorderRadius: 20,
        currentIndex: globalWatch.selectedTab,
        items: [
          // FloatingNavbarItem(icon: Icons.home, title: 'Home'),
          navBarItem(0, "Home", Icons.home),
          navBarItem(1, "Alarm", Icons.add),
          navBarItem(2, "Devices", Icons.explore),
          navBarItem(3, "Profile", Icons.person),
        ],
      ),
    ],
  );
}

FloatingNavbarItem navBarItem(int index, String label, IconData icon) {
  return FloatingNavbarItem(
      customWidget: Column(
    children: [
      Icon(
        icon,
        size: 24,
        color: Colors.white,
      ),
      FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(
          label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      )
    ],
  ));
}
