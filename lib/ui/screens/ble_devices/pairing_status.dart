import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';

import '../../../methods/globals.dart';
import '../../theme/theme.dart';
import '../home.dart';
import 'pairing_device.dart';

// ignore: must_be_immutable
class PairingStatusScreen extends StatelessWidget {
  PairingStatusScreen({required this.success, super.key});

  bool success;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: success
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  'assets/images/logo2.png',
                  height: w * 0.4,
                  width: w * 0.4,
                ),
                Flexible(
                  child: Text(
                    "You're Paired!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/wearable2.png',
                          height: w * 0.3,
                          width: w * 0.3,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Image.asset(
                              'assets/images/check1.png',
                            ),
                          ),
                        ),
                        Image.asset(
                          'assets/images/phone.png',
                          height: w * 0.3,
                          width: w * 0.3,
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.1, vertical: h * 0.05),
                    child: Text(
                      "Time to set your alarms and never worry about them again.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 17, color: Colors.black54, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Flexible(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryColor,
                        fixedSize: Size(w * 0.7, h * 0.07),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => HomeScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    child: Text(
                      'Continue',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: w * 0.1),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(40))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        'Not Connected!',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 20, color: primaryColor.withOpacity(0.9), fontWeight: FontWeight.w600),
                      ),
                    ),
                    RotatedBox(
                      quarterTurns: 3,
                      child: Image.asset(
                        'assets/images/wearable2.png',
                        height: w * 0.4,
                        width: w * 0.4,
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Text(
                          "Failed to connect your wearable.\nPress connect below to try again.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Flexible(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            fixedSize: Size(w * 0.5, h * 0.07),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            )),
                        onPressed: () async {
                          FlutterBlue.instance.startScan(timeout: Duration(seconds: 4));
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PairDeviceScreen(
                                      firstTime: true,
                                    )),
                          );
                        },
                        child: Text(
                          'Connect',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) => HomeScreen(),
                              ),
                              (route) => false,
                            );
                          },
                          child: Text(
                            "Pair Later",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    ));
  }
}
