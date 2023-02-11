import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';

import '../../../methods/globals.dart';
import '../../theme/theme.dart';
import '../home.dart';
import 'pairing_device.dart';

class PairingScreen extends StatefulWidget {
  const PairingScreen({super.key});

  @override
  State<PairingScreen> createState() => _PairingScreenState();
}

class _PairingScreenState extends State<PairingScreen> {
  int selectedCircle = 0;

  Widget circleIndicator(int value) {
    return Container(
      width: w * 0.03,
      height: w * 0.03,
      decoration: BoxDecoration(
        color: value == 5
            ? Colors.orange.withOpacity(0.6)
            : value == selectedCircle
                ? primaryColor.withOpacity(0.4)
                : Colors.orange.withOpacity(0.6),
        shape: BoxShape.circle,
      ),
    );
  }

  Timer? timer;
  final controller = ValueNotifier<bool>(true);

  @override
  initState() {
    super.initState();

    timer = Timer.periodic(Duration(milliseconds: 500), (timer) async {
      setState(() {
        if (selectedCircle == 3) {
          selectedCircle = 0;
        } else {
          selectedCircle++;
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            'assets/images/logo2.png',
            height: w * 0.5,
            width: w * 0.5,
          ),
          Flexible(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                "Connect Your Wearable.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 27, color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.05),
              child: Text(
                "( Hold down the sync button of your wearable to pair it with your mobile device )",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17, color: Colors.white70, fontWeight: FontWeight.w500),
              ),
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
                      flex: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          circleIndicator(0),
                          circleIndicator(1),
                          circleIndicator(2),
                          circleIndicator(3),
                        ],
                      )),
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
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor.withOpacity(0.7),
                  fixedSize: Size(w * 0.7, h * 0.07),
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
                'Pair Device',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Flexible(
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
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                circleIndicator(5),
                circleIndicator(5),
                circleIndicator(5),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
