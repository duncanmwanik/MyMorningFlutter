import 'package:flutter/material.dart';
import '../../../variables/global_variables.dart';
import '../../../helpers/datetime_helper.dart';
import '../../../config/theme/theme.dart';

Widget sliverAppBar(double scroll) {
  return SliverAppBar(
    pinned: true,
    elevation: 0,
    expandedHeight: h * 0.18,
    backgroundColor: primaryColor,
    flexibleSpace: FlexibleSpaceBar(
      centerTitle: true,
      stretchModes: [StretchMode.fadeTitle],
      background: Image.asset(
        "assets/images/morning.jpeg",
        fit: BoxFit.fill,
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Visibility(
              visible: scroll < h * 0.07,
              child: Image.asset(
                'assets/images/logo-trp.png',
                height: w * 0.1,
                width: w * 0.1,
              ),
            ),
          ),
          Flexible(
            child: Visibility(
              visible: scroll < h * 0.07,
              child: FittedBox(
                child: SizedBox(
                  width: w,
                  child: Text(
                    "7 Day Alarm Schedule",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 22, fontFamily: "Poppins", color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w500),
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
                style: TextStyle(fontSize: 18, color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget sliverAppbarHeader() {
  return SliverLayoutBuilder(
    builder: (BuildContext context, constraints) {
      return sliverAppBar(constraints.scrollOffset);
    },
  );
}
