// --------------------------------- Shared Preferences ---------------------------------
import 'package:shared_preferences/shared_preferences.dart';

import '../methods/globals.dart';

late SharedPreferences prefs;

void setFirstTimeState() async {
  // set first time running the app to false
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("firstTime", false);
}

// update alarmNames in storage
void saveAlarmNames() {
  prefs.setString("alarmnames", globalWatch.alarmNames);
}
