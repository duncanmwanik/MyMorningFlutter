import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../_variables/global_variables.dart';
import '../../state/global_state.dart';
import '../theme/theme.dart';

Widget onPairingScreen() {
  Widget circleIndicator(Color? paint) {
    return Container(
      width: w * 0.03,
      height: w * 0.03,
      decoration: BoxDecoration(
        color: paint,
        shape: BoxShape.circle,
      ),
    );
  }

  return Consumer<GlobalModel>(builder: (context, global, child) {
    return Visibility(
      // visible: true,
      visible: global.onPairing,
      child: Container(
        height: h,
        width: w,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: h * 0.04,
            ),
            Image.asset(
              'assets/images/logo2.png',
              height: w * 0.5,
              width: w * 0.5,
            ),
            SizedBox(
              height: h * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  "Connect Your Wearable.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "Poppins", color: Colors.white, fontWeight: FontWeight.w500, decoration: TextDecoration.none),
                ),
              ),
            ),
            SizedBox(
              height: h * 0.03,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.05),
              child: Text(
                "Hold down the sync button of your wearable to pair it with your mobile device",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 17,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: h * 0.04, bottom: h * 0.08),
              child: Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/wearable2.png',
                      height: w * 0.3,
                      width: w * 0.3,
                    ),
                  ),
                  Expanded(
                      child: Wrap(
                    alignment: WrapAlignment.spaceAround,
                    children: [
                      circleIndicator(Colors.orange.withOpacity(0.6)),
                      circleIndicator(Colors.orange.withOpacity(0.6)),
                      circleIndicator(Colors.orange.withOpacity(0.6)),
                      circleIndicator(primaryColor.withOpacity(0.4)),
                    ],
                  )),
                  Expanded(
                    child: Image.asset(
                      'assets/images/phone.png',
                      height: w * 0.3,
                      width: w * 0.3,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Text(
                "Pairing...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                  shadows: [
                    Shadow(
                      blurRadius: 1.0, // shadow blur
                      color: Colors.black38, // shadow color
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  });
}
