import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../../methods/alarms/alarms.dart';
import '../../methods/ble.dart';
import '../../methods/datetime.dart';
import '../../methods/globals.dart';
import '../../state/globals.dart';
import '../widgets/alarm_widget.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/date_widget.dart';
import '../widgets/sliver_appbar.dart';
import '../widgets/toast.dart';
import 'alarm_actions/alarm_add.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget noAlarmBox() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * 0.1, vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Text(
        'No alarms set today',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w600),
      ),
    );
  }

  @override
  initState() {
    super.initState();

    // listen for changes in Bluetooth state
    FlutterBlue.instance.state.listen((event) {
      if (event == BluetoothState.on) {
        bleWatch.updateBtState(true);
      } else if (event == BluetoothState.off) {
        toast(0, "Bluetooth is off!");
        bleWatch.updateBtState(false);
        bleWatch.setDevice(null);
        bleWatch.setConnectionState(false);
      }
    });

    checkAlreadyConnectedDevices();
  }

  @override
  Widget build(BuildContext context) {
    // get device screen size and save them globally
    getDeviceSize(context);

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/back.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: GestureDetector(
        onHorizontalDragEnd: (details) => swipe(details),
        child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          body: CustomScrollView(
            shrinkWrap: true,
            slivers: <Widget>[
              // ***************** App intro / Week title *************************
              SliverLayoutBuilder(
                builder: (BuildContext context, constraints) {
                  return sliverAppBar(constraints.scrollOffset);
                },
              ),

              // ***************** Day Title *************************
              SliverList(
                  delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 0),
                  child: Text(
                    getWeekDay(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ),
                // ***************** Black Line *************************
                Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 2.5, left: w * 0.05, right: w * 0.05),
                      height: 2,
                      color: Colors.black,
                    ),
                    Consumer<GlobalModel>(builder: (context, global, child) {
                      Map<int, List<String>> mapD = global.alarmMap;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          dateIcon(dayNumber: 0, alarmNumber: mapD[0]!.length),
                          dateIcon(dayNumber: 1, alarmNumber: mapD[1]!.length),
                          dateIcon(dayNumber: 2, alarmNumber: mapD[2]!.length),
                          dateIcon(dayNumber: 3, alarmNumber: mapD[3]!.length),
                          dateIcon(dayNumber: 4, alarmNumber: mapD[4]!.length),
                          dateIcon(dayNumber: 5, alarmNumber: mapD[5]!.length),
                          dateIcon(dayNumber: 6, alarmNumber: mapD[6]!.length),
                        ],
                      );
                    }),
                  ],
                ),

                SizedBox(
                  height: 10,
                ),
                // ***************** Add Alarm button *************************
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddAlarmScreen(
                                    selectedDays: [globalWatch.selectedDate],
                                    alarmTime: TimeOfDay.now(),
                                    alarmActive: 1,
                                    alarmRepeat: 1,
                                    vibrationPattern: 0,
                                    vibrationStrength: 9,
                                    snoozeOn: 0,
                                    snoozeMin: 1,
                                  )),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white70,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              "${weekDaysList[globalWatch.selectedDate].dayName}'s Alarms",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w700),
                            ),
                          ),
                          Icon(
                            Icons.add_circle,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // ***************** Alarm List *************************

                Consumer<GlobalModel>(builder: (context, global, child) {
                  if (global.alarmMap[global.selectedDate] != null) {
                    if (global.alarmMap[global.selectedDate]!.isNotEmpty) {
                      List<String> sortedList = sortAlarmsByTime(global.alarmMap[global.selectedDate]!);

                      return ListView.builder(
                          itemCount: sortedList.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            String alarm = sortedList[index];
                            int hour = int.parse(alarm.substring(6).split(":")[0]);
                            int min = int.parse(alarm.substring(6).split(":")[1]);
                            // 11091513:26
                            // 1-1-0-9-1-5-13:26
                            //[ alarmActive-alarmRepeat-vibrationPattern-vibrationStrength-snoozeOn-snoozeMin-time ]
                            return AlarmWidget(
                              day: global.selectedDate,
                              alarmActive: int.parse(alarm[0]),
                              alarmRepeat: int.parse(alarm[1]),
                              vibrationPattern: int.parse(alarm[2]),
                              vibrationStrength: int.parse(alarm[3]),
                              snoozeOn: int.parse(alarm[4]),
                              snoozeMin: int.parse(alarm[5]),
                              alarmTime: TimeOfDay(hour: hour, minute: min),
                              alarmName: "My Alarm Dummy",
                            );
                          });
                    } else {
                      return noAlarmBox();
                    }
                  } else {
                    return noAlarmBox();
                  }
                }),

                // testAlarms()
              ]))
            ],
          ),
          // ***************** Custom Bottom Nav Bar  *************************
          bottomNavigationBar: bottomNavbar(context),
          // floatingActionButton: Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     FloatingActionButton(
          //       heroTag: null,
          //       onPressed: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(builder: (context) => SignUpScreen()),
          //         );
          //       },
          //       child: Icon(Icons.person),
          //     ),
          //     SizedBox(
          //       width: 10,
          //     ),
          //     FloatingActionButton(
          //       heroTag: null,
          //       onPressed: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(builder: (context) => LoginScreen()),
          //         );
          //       },
          //       child: Icon(Icons.login),
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
