import 'package:flutter/material.dart';
import '../../methods/datetime.dart';
import '../../methods/globals.dart';
import '../theme/theme.dart';

Widget sliverAppBar(double scroll) {
  return SliverAppBar(
    pinned: true,
    elevation: 0,
    expandedHeight: h * 0.25,
    backgroundColor: primaryColor,
    flexibleSpace: FlexibleSpaceBar(
      centerTitle: true,
      stretchModes: [StretchMode.fadeTitle],
      title: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Visibility(
              visible: scroll < h * 0.1,
              child: Image.asset(
                'assets/images/logo-trp.png',
                height: w * 0.15,
                width: w * 0.15,
              ),
            ),
          ),
          Flexible(
            child: Visibility(
              visible: scroll < h * 0.15,
              child: FittedBox(
                child: SizedBox(
                  width: w,
                  child: Text(
                    "7 Day Alarm Schedule",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: "Poppins",
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ),
          FittedBox(
            child: SizedBox(
              width: w,
              child: Text(
                getWeekRange(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
      background: Image.asset(
        "assets/images/morning.jpeg",
        fit: BoxFit.fill,
      ),
    ),
  );
}
