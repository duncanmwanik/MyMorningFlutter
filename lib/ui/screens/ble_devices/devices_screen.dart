import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';
import '../../../logic/ble_logic.dart';
import '../../../_variables/global_variables.dart';
import '../../../state/ble_state.dart';
import '../../theme/theme.dart';
import '../../widgets/back_button.dart';
import '../../widgets/battery_icon.dart';
import '../../widgets/bottom_navbar.dart';
import '../../widgets/change_name_dialog.dart';
import '../../widgets/toast.dart';
import '../home/home_screen.dart';
import 'devices.dart';
import 'pair_device_screen.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  Timer? timer;
  final controller = ValueNotifier<bool>(true);

  @override
  initState() {
    super.initState();

    controller.addListener(() {
      if (controller.value) {
      } else {
        turnOffDevice();
      }
    });

    timer = Timer.periodic(Duration(seconds: 10), (timer) async {
      await getBatteryPercentage();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<bool> onWillPop() async {
    await globalWatch.updateSelectedTab(0);
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => HomeScreen(),
      ),
      (route) => false,
    );

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/back.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: customBackButton(context, primaryColor),
            centerTitle: true,
            title: Column(
              children: [
                Text(
                  'My Devices',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: primaryColor),
                ),
                Divider(
                  thickness: 2,
                  color: primaryColor,
                  indent: w * 0.05,
                  endIndent: w * 0.05,
                )
              ],
            ),
            actions: [
              IconButton(
                  onPressed: () async {
                    if (bleWatch.connected) {
                      toast(2, "Already connected to a device!");
                    } else if (!bleWatch.btState) {
                      toast(0, "Bluetooth is off!");
                    } else {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PairDeviceScreen(
                                  firstTime: false,
                                )),
                      );
                    }
                  },
                  icon: Icon(
                    Icons.add_circle,
                    color: Colors.green,
                    size: 30,
                  ))
            ],
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          bottomNavigationBar: bottomNavbar(context, false),
          body: Consumer<BleModel>(builder: (context, ble, child) {
            return ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Connect your wearable \n and check its battery percentage',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Color(0xFF5C4982), fontWeight: FontWeight.w600),
                  ),
                ),
                ble.connected
                    ? Container(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        padding: EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(color: Colors.white60, borderRadius: BorderRadius.all(Radius.circular(40))),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: w * 0.1, vertical: 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      ble.device!.name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 18, color: primaryColor, fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        TextEditingController? textController = TextEditingController(text: ble.device!.name);

                                        bool success = await changeNameDialog(
                                            context: context,
                                            description: "Edit device name",
                                            textController: textController,
                                            maxLength: 19,
                                            onTap: () {
                                              if (textController.text.isNotEmpty && textController.text.length < 20) {
                                                sendDataToDevice("n${textController.text}");
                                                Navigator.pop(context, true);
                                              } else if (textController.text.length >= 20) {
                                                toast(0, "Name is too long!");
                                              } else {
                                                toast(0, "Name is too short!");
                                              }
                                            });

                                        if (success) {
                                          toast(1, "Please restart your device to see changes.");
                                        }
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: primaryColor,
                                      ))
                                ],
                              ),
                            ),
                            Wrap(
                              alignment: WrapAlignment.spaceEvenly,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  ble.batteryPercentage == 404 ? "X" : "${ble.batteryPercentage}%",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                batteryIcon(ble.batteryPercentage),
                                SizedBox(
                                  width: w * 0.15,
                                ),
                                AdvancedSwitch(
                                  activeChild: Text('ON'),
                                  inactiveChild: Text('OFF'),
                                  borderRadius: BorderRadius.circular(5),
                                  width: 76,
                                  controller: controller,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                disconnectFromDevice();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black12,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  )),
                              child: Text(
                                "disconnect",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(color: Colors.white60, borderRadius: BorderRadius.all(Radius.circular(40))),
                        child: Column(
                          children: [
                            Text(
                              'No Devices Connected',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18, color: primaryColor, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor.withOpacity(0.7),
                                  fixedSize: Size(w * 0.7, h * 0.07),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  )),
                              onPressed: () async {
                                if (ble.btState) {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Devices(
                                              firstTime: false,
                                            )),
                                  );
                                  // await Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => PairDeviceScreen(
                                  //             firstTime: false,
                                  //           )),
                                  // );
                                } else {
                                  toast(0, "Bluetooth is off!");
                                }
                              },
                              child: Text(
                                'Pair Device',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
