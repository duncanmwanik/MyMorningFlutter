import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../../variables/ble_variables.dart';
import '../../helpers/alarms_helper.dart';
import '../../helpers/ble_helper.dart';
import '../../helpers/global_helper.dart';
import '../../variables/global_variables.dart';
import '../../../widgets/bottom_navbar.dart';
import '../../../widgets/confirm_exit_app_dialog.dart';
import '../../../widgets/toast.dart';
import 'home_widgets/current_weekday.dart';
import 'home_widgets/new_alarm_button.dart';
import 'home_widgets/alarm_list.dart';
import 'home_widgets/weekdays_row.dart';
import 'home_widgets/sliver_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  initState() {
    super.initState();

    getBLEPermissions();

    Future.delayed(Duration.zero, () async {
      loadAlarmNamesFromPhoneStorage();
    });

    rble.statusStream.listen((status) {
      if (status == BleStatus.ready) {
        bleWatch.updateBtState(true);
      } else if (status == BleStatus.poweredOff) {
        toast(0, "Bluetooth is off!");
        bleWatch.updateBtState(false);
        bleWatch.setDevice(null);
        bleWatch.setConnectionState(false);
      }
    });

    // checkAlreadyConnectedDevices();
  }

  Future<bool> onWillPop() async {
    return (await showConfirmExitApp(context)) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    getDeviceScreenDimensions(context); // get device screen dimensions and save it globally

    return WillPopScope(
      onWillPop: onWillPop,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/back.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: GestureDetector(
          onHorizontalDragEnd: (details) =>
              swipeToAnotherDay(details), // allows selecting another day on swipe-left(next day) or swipe-right(previous day)
          child: Scaffold(
            extendBody: true,
            backgroundColor: Colors.transparent,
            bottomNavigationBar: bottomNavbar(context, true),
            body: CustomScrollView(
              shrinkWrap: true,
              slivers: <Widget>[
                // ------------------------------ Appbar/ Week title
                sliverAppbarHeader(),
                SliverList(
                    delegate: SliverChildListDelegate([
                  // ------------------------------ Day Title
                  currentWeekDay(),

                  // ------------------------------ 7-Day Bubbles
                  weekdayBubblesRow(context),

                  // ------------------------------ Add Alarm button
                  addAlarmButton(context),

                  // ------------------------------ Alarms List for the selected day
                  alarmList(context),

                  // testAlarms()
                ]))
              ],
            ),
          ),
        ),
      ),
    );
  }
}