import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter/material.dart';

import '../../../../_variables/global_variables.dart';
import '../../../theme/theme.dart';
import '../../../widgets/back_button.dart';
import '../../ble_devices/pairing_screen.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  int state = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          backgroundColor: primaryColor,
          leading: customBackButton(context, Colors.white),
          title: const Text('Permissions'),
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: w * 0.1),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(40))),
            child: state == 0
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: h * 0.01,
                      ),
                      Text(
                        "'MyMorning' Would Like to \n Use Bluetooth",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      Text(
                        "Enable bluetooth access to start using your wearable.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: h * 0.02,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            fixedSize: Size(w * 0.7, h * 0.07),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            )),
                        onPressed: () {
                          // this asks for location persions, instead of using permission handler
                          // FlutterBluePlus.instance.startScan(timeout: Duration(seconds: 4));
                          setState(() {
                            state = 1; // move to next permission
                          });
                        },
                        child: Text(
                          'Enable Bluetooth',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            state = 1;
                          });
                        },
                        child: Text(
                          "No Thanks",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: h * 0.01,
                      ),
                      Text(
                        'Push Notifications',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      Text(
                        "Enable push notifications to get app alerts on your phone.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: h * 0.02,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            fixedSize: Size(w * 0.7, h * 0.07),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            )),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) => PairingScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        child: Text(
                          'Push Notifications',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) => PairingScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        child: Text(
                          "No Thanks",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
          ),
        ));
  }
}
