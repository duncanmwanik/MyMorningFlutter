import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../../logic/alarms_logic.dart';
import '../../../logic/ble_logic.dart';
import '../../../logic/datetime_logic.dart';
import '../../../logic/global_logic.dart';
import '../../../_variables/global_variables.dart';
import '../../widgets/bottom_navbar.dart';
import '../../widgets/confirm_exit_app_dialog.dart';
import '../../widgets/toast.dart';
import 'home_widgets/new_alarm_button.dart';
import 'home_widgets/alarm_list.dart';
import 'home_widgets/day_bubbles.dart';
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

    Future.delayed(Duration.zero, () async {
      loadAlarmNamesFromPhoneStorage();
    });

    // listen for changes in Bluetooth state
    FlutterBluePlus.instance.state.listen((event) {
      if (event == BluetoothState.on) {
        bleWatch.updateBtState(true);
      } else if (event == BluetoothState.off) {
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
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 0),
                    child: Text(
                      getWeekDay(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                  ),

                  // ------------------------------ 7-Day Bubbles
                  dayBubbles(context),

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
