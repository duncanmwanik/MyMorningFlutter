import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../../methods/globals.dart';
import '../theme/theme.dart';
import '../screens/alarm_actions/alarm_add.dart';
import '../screens/ble_devices/devices.dart';
import '../screens/home.dart';
import '../screens/profile_settings/profile.dart';

Widget bottomNavbar(BuildContext context) {
  List<dynamic> tabs = [
    HomeScreen(),
    AddAlarmScreen(
      selectedDays: [globalWatch.selectedDate],
      alarmTime: TimeOfDay.now(),
      alarmActive: 1,
      alarmRepeat: 1,
      vibrationPattern: 0,
      vibrationStrength: 9,
      snoozeOn: 0,
      snoozeMin: 5,
    ),
    DevicesScreen(),
    ProfileScreen()
  ];

  Widget circleIndicator(int day) {
    return Container(
      width: w * 0.03,
      height: w * 0.03,
      decoration: BoxDecoration(
        color: day == globalWatch.selectedDate ? primaryColor : Colors.black26,
        shape: BoxShape.circle,
      ),
    );
  }

  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(
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
      ),
      FloatingNavbar(
        onTap: (int val) {
          if (val != 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => tabs[val]),
            );
          }
        },
        elevation: 0,
        backgroundColor: primaryColor,
        selectedBackgroundColor: Colors.transparent,
        selectedItemColor: Colors.white,
        borderRadius: 40,
        itemBorderRadius: 40,
        currentIndex: globalWatch.selectedTab,
        items: [
          FloatingNavbarItem(icon: Icons.home, title: 'Home'),
          FloatingNavbarItem(icon: Icons.add, title: 'Add Alarm'),
          FloatingNavbarItem(icon: Icons.explore, title: 'Devices'),
          FloatingNavbarItem(icon: Icons.person, title: 'Profile'),
        ],
      ),
    ],
  );
}
